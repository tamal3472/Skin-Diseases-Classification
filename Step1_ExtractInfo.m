% Copyright (c) 2018, Lucia Maddalena
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% * The above copyright notice and this permission notice shall be included in all
%   copies or substantial portions of the Software.
% * In case results obtained with the present software, or parts of it, are
%   published in a scientific paper, the following reference should be cited:
%
%   M.R. Guarracino, L. Maddalena, SDI+: a Novel Algorithm for Segmenting Dermoscopic Images, 
%   to be published in IEEE Journal of Biomedical and Health Informatics (2018), 
%   DOI: 10.1109/JBHI.2018.2808970
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Computes the masks of Dark Areas, Hihglights, and Hair in Img
%
function [Iout, B, Dark, Highlights, Hair] = Step1_ExtractInfo(Img, show)
%
%In output provides also:
%- Iout = Img without dark borders
%- B    = information on the excluded border
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Adjustable parameters:
    Black      = 0.2;  %Threshold for the Value to detect Dark Areas
    Sizestrel  = 5;    %Size of structuring element to detect Hair
    MinHthresh = 0.05; %Minimum Hair threshold
    MinSat     = 0.1;  %Min. Saturation for non-highlights
    Beta       = 0.01; %Sets inclination of highlight cone
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %1) Extracts dark borders of the image (--> Dark1)
    HSV = rgb2hsv(Img);
    Dark0 = bwmorph(HSV(:,:,3)<Black,'fill');
    [Dark1, B] = MaskBorder(Dark0);
    %Excludes dark borders by subsequent computations
    HSVout = HSV(1+B(1):size(Img,1)-B(2),1+B(3):size(Img,2)-B(4),:); 
    Iout   = Img(1+B(1):size(Img,1)-B(2),1+B(3):size(Img,2)-B(4),:); 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %2) Extracts dark corners of the image (detected as CCs in Dark1 
    %   positioned in one of the four corners), and computes the ROI
    L = bwlabel(Dark1); s1=size(L,1); s2=size(L,2);
    if (L(1,1)),   C1 = L==L(1,1);   else C1 = L<0; end
    if (L(s1,1)),  C2 = L==L(s1,1);  else C2 = L<0; end
    if (L(1,s2)),  C3 = L==L(1,s2);  else C3 = L<0; end
    if (L(s1,s2)), C4 = L==L(s1,s2); else C4 = L<0; end
    Dark = C1|C2|C3|C4;
    %If Corners occupy more than 50% of the image, it could be a big dark
    %lesion (so, reset Corners)
    if (sum(Dark(:))>numel(Dark)/2)
        Dark = createCorners(size(Dark,1),size(Dark,2),15);
        disp('Resetting corners...');
    end
    ROI=imcomplement(Dark);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %3) Detects Highlights and updates the ROI
    Highlights = ROI & ...                    %excludes Dark Areas
                 (HSVout(:,:,2)<MinSat) & ... %low saturation & high value
                 (imadjust(HSVout(:,:,3))>=(1+HSVout(:,:,2)*(Beta-MinSat)/MinSat));
    %Add the (complement of) Highlights to the ROI
    ROI = ROI & imcomplement(Highlights);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %4) Detects Hair, using bottomhat filter in the Red band of Img (Iout(:,:,1))
    Hair0 = imbothat(Iout(:,:,1),strel('disk',Sizestrel));
    %Computes Otsu threshold TauH in Hair0 using only ROI elements
    TauH = graythresh(Hair0(ROI));

    %If the threshold is too small, too many (fake) hair would be detected 
    %(so, set to a null mask)
    if (TauH>MinHthresh)
        Hair = ROI & ...                  %excludes Dark Areas and Highlights
               bwmorph(im2bw(Hair0,TauH),'clean');
        %Add the (complement of) HairMask to the ROI
        ROI = ROI & imcomplement(Hair);
    else
        Hair = ROI<0;
    end
    
    if (show)
        figure('Name','Step 1: Preliminary Information Extraction'); 
        subplot(2,3,1); imshow(Img);        title('Input image');
        subplot(2,3,2); imshow(Dark);       title('Dark areas mask');
        subplot(2,3,3); imshow(Highlights); title('Highlights mask');
        subplot(2,3,5); imshow(Hair);       title('Hair mask');
        subplot(2,3,6); imshow(ROI);        title('ROI mask');
    end
    clear HSV HSVout Dark0 Dark1 L Hair0 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Given a binary input Mask, it:
% a) detects its borders made of white pixels (up to a fixed percentage perc)
% b) adds corners of size Height/cornerFactor
% c) extracts the internal SubMask, excluding the above borders
function [SubMask, Border] = MaskBorder(Mask)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Adjustable parameters:
    perc=10;         %Percentage of border elements that can be black
    cornerFactor=15; %Factor for determining corners size
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %a) Detects borders made of white pixels (up to a fixed percentage perc)
    TauR=floor(size(Mask,1)/perc);
    TauC=floor(size(Mask,2)/perc);
    %Left border (BorderC1)
    BorderC1=0; Done=0;
    while (~Done && BorderC1<size(Mask,2)-1)
        s=sum(Mask(:,BorderC1+1));
        if ((size(Mask,1)-s)<TauR)
            BorderC1=BorderC1+1;
        else
            Done=1;
        end
    end
    %Upper border (BorderR1)
    BorderR1=0; Done=0;
    while (~Done && BorderR1<size(Mask,1)-1)
        s=sum(Mask(BorderR1+1,:));
        if ((size(Mask,2)-s)<TauC)
            BorderR1=BorderR1+1;
        else
            Done=1;
        end
    end
    %Right border (BorderC2)
    BorderC2=0; Done=0;
    while (~Done && BorderC2<size(Mask,2)-1)
        s=sum(Mask(:,size(Mask,2)-BorderC2));
        if ((size(Mask,1)-s)<TauR)
            BorderC2=BorderC2+1;
        else
            Done=1;
        end
    end
    %Lower border (BorderR2)
    BorderR2=0; Done=0;
    while (~Done && BorderR2<size(Mask,1)-1)
        s=sum(Mask(size(Mask,1)-BorderR2,:));
        if ((size(Mask,2)-s)<TauC)
            BorderR2=BorderR2+1;
        else
            Done=1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %b) Adds corners of size Height/cornerFactor
    Corners=(createCorners(size(Mask,1),size(Mask,2),cornerFactor)|Mask);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %c) Extracts the internal SubMask, excluding the above borders
    Border=[BorderR1, BorderR2, BorderC1, BorderC2];
    SubMask=uint8(Corners(1+BorderR1:size(Mask,1)-BorderR2,...
                          1+BorderC1:size(Mask,2)-BorderC2,:));
end
