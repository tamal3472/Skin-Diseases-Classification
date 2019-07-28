% Copyright (c) 2017, Lucia Maddalena
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
%   M.R. Guarracino, L. Maddalena, SDI: a Novel Algorithm for Segmenting Dermoscopic Images, 
%   to be published in IEEE Journal of Biomedical and Health Informatics (2017), 
%   DOI: 10.1109/JBHI.2017.2808970
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
%Given the input Img image and the Dark, Hair, and Highlights masks,
%1) Computes RNorm (Normalized Red channel) and its best CC 
%2) Computes Vcompl (complement of the Value band) and its best CC 
%3) Chooses the best band (between RNorm and Vcompl)
%4) Provides in output the (initial) segmented lesion (BWout)
%
function [BWout] = Step2_SegmentAndSelect(Img, Dark, Hair, Highlights, show)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Adjustable parameters:
    TauExtension = 0.1; %Threshold to avoid CCs covering the entire ROI
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %1) Computes RNorm (Normalized Red channel) and its best CC 
    DD    = im2double(Img);
    RNorm = DD(:,:,1)./sum(DD,3);
    
    %- Binarizes RNorm
    [BWR1, B0R, inpRNorm] = Segment(RNorm, Dark, Hair, Highlights, 'Rnorm', show);

    %- Computes best CC in RNorm
    [BWR, DistR] = ChooseCC(BWR1, 'Rnorm', show);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %2) Computes Vcompl (complement of the Value channel) and its best CC 
    HSV    = rgb2hsv(Img);
    Vcompl = imcomplement(HSV(:,:,3));

    %- Binarizes Vcompl
    [BWV1, B0V, inpVcompl] = Segment(Vcompl, Dark, Hair, Highlights, 'Vcompl', show);

    %- Computes best CC in Vcompl
    [BWV, DistV] = ChooseCC(BWV1, 'Vcompl', show);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %3) Chooses the best band (between RNorm and Vcompl)

    %Sets conditions for choosing the segmentation band:
    statsR = regionprops(BWR,'BoundingBox','ConvexArea');
    BBofR  = statsR(1).BoundingBox;
    BWR2 = BWR&imcomplement(Hair|Highlights);%Excludes inpainted pixels
    SolR = sum(BWR2(:))/statsR(1).ConvexArea;
    
    statsV = regionprops(BWV,'BoundingBox','ConvexArea');
    BBofV  = statsV(1).BoundingBox;
    BWV2 = BWV&imcomplement(Hair|Highlights);%Excludes inpainted pixels
    SolV = sum(BWV2(:))/statsV(1).ConvexArea;

    %a) CC not covering the whole ROI
    maskROI = imcomplement(Dark | Hair | Highlights);
    PercROI = sum(maskROI(:))/numel(maskROI);
    PercR = sum(BWR(:))/numel(maskROI);
    PercV = sum(BWV(:))/numel(maskROI);
    ROK = (size(BWR,1)-BBofR(4)>2) | (size(BWR,2)-BBofR(3)>2) | ...
                                     (PercROI-PercR>TauExtension);
    VOK = (size(BWV,1)-BBofV(4)>2) | (size(BWV,2)-BBofV(3)>2) | ...
                                     (PercROI-PercV>TauExtension);

    %b) Chooses the most solid CC
    Cond1 = (SolV>SolR);

    %c) Chooses the CC closest to the image center
    Cond2 = (DistR>DistV);

    %d) Chooses the most contrasted CC
    InV       = BWV2 & B0V & maskROI;
    OutV      = imcomplement(BWV) & maskROI;
    [VA]      = imadjustROI(inpVcompl, maskROI);
    vin       = mean(VA(InV));
    vout      = mean(VA(OutV));
    contrastV = (vin-vout)/vout;

    InR       = BWR2 & B0R & maskROI;
    OutR      = imcomplement(BWR) & maskROI;
    [RA]      = imadjustROI(inpRNorm, maskROI);
    rin       = mean(RA(InR));
    rout      = mean(RA(OutR));
    contrastR = (rin-rout)/rout;

    Cond3 = contrastV > contrastR;

    %e) Averages the conditions
    Cond = (Cond1 + Cond2 + Cond3)>1;

    if (Cond && VOK || not(ROK))
        Case  = ' Vcompl';
        BWout = BWV;
    else
        Case  = ' Rnorm';
        BWout = BWR;
    end

    if (show)
        figure('Name','Step 2-B: Segmentation Selection'); nr=2; nc=3; i=1;
        subplot(nr,nc,i); i=i+1; imshow(Img,[]);    title('Input image');
        subplot(nr,nc,i); i=i+1; imshow(RNorm,[]);  title('Rnorm');
        subplot(nr,nc,i); i=i+1; imshow(Vcompl,[]); title('Vcompl');
        subplot(nr,nc,i); i=i+1; imshow(BWout,[]); 
        title(strcat('Chosen segmentation:', Case));        
        subplot(nr,nc,i); i=i+1; imshow(BWR);        
        title('Segmentation of Rnorm');        
        xlabel(sprintf('d_C=%.2f, S=%.2f, c=%.2f',DistR,SolR,contrastR));
        subplot(nr,nc,i); imshow(BWV);        
        title('Segmentation of Vcompl');        
        xlabel(sprintf('d_C=%.2f, S=%.2f, c=%.2f',DistV,SolV,contrastV));
    end
    clear HSV DD RNorm RNormv inpRNorm BWR Vcompl Vcomplv inpVcompl BWV statsR statsV
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Given the input Img band and the Dark, Hair, and Highlights masks,
%a) applies inpainting to Highlights and Hair in Img
%b) segments Img, providing in output:
%- the segmented mask (BW0) 
%- the refinement of BW0 (BWout)
%- the inpainted Img (inpImg)
%
function [BWout, BW0, inpImg] = Segment(Img, Dark, Hair, Highlights, Title, show)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Adjustable parameters:
    dimHighlight = 1;   %Size of the dilation filter for Highlight
    dimHair      = 2;   %Size of the dilation filter for Hair
    MaxRatio     = 0.1; %Max percentage of Highlight/Hair to apply inpanting

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %a) Inpainting
    %- Conditions for applying inpainting (there are Highlights/Hair, but not too many)
    HighlightsRatio = sum(Highlights(:))/numel(Highlights);
    CondHighlights  = (HighlightsRatio > 0) & (HighlightsRatio < MaxRatio);
    HairRatio       = sum(Hair(:))/numel(Hair);
    CondHair        = (HairRatio > 0) & (HairRatio < MaxRatio);

    if (CondHighlights)
        [inpImg, Remaining] = inpaintROI(Img, Highlights, dimHighlight);
    else
        inpImg = Img;
        Remaining = Highlights;
    end
    
    if (show)
        figure('Name',sprintf('Step 2-A: Inpainting %s',Title)); 
        nr=2; nc=3; i=1;
        subplot(nr,nc,i);i=i+1; imshow(Img);        title('Input image');
        subplot(nr,nc,i);i=i+1; imshow(Highlights); title('Highlights mask');
        subplot(nr,nc,i);i=i+1; imshow(inpImg);     title('Inpainted Highlights');
    end
    if (CondHair)
        [inpImg, Remaining1] = inpaintROI(inpImg, Hair, dimHair);
        Remaining = Remaining|Remaining1;
        clear Remaining1
    else
        Remaining=Remaining|Hair;
    end
    if (show)
        i=i+1; 
        subplot(nr,nc,i);i=i+1; imshow(Hair);   title('Hair mask');
        subplot(nr,nc,i);       imshow(inpImg); title('Inpainted Hair');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %b) Segmentation
    %
    %Selects elements to be used for thresholding (--> Included):
    %- Mask of non-inpainted elements
    ROImask = imcomplement(Dark | Remaining);

    %- Image corners, that are often darker than center areas
    [WiderDark] = createCorners(size(Img,1),size(Img,2),3);

    %Otsu threshold of Img, excluding non-ROI elements
    Included = ROImask & imcomplement(WiderDark);
    Tau = graythresh(inpImg(Included));
   
    %Basic segmentation (--> BW0)
    BW0 = (inpImg>Tau) & ROImask;

    %Refined segmentation (--> BWout)
    BWout = bwmorph(bwmorph(BW0,'majority'),'close'); 

    clear Remaining ROImask WiderDark Included
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inpaints I in Mask areas
%
function [Inpainted, Remaining]=inpaintROI(I, Mask, dim)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Dilated Mask (so that inpainting takes as input more certain values)
    DilMask   = bwmorph(Mask,'dilate',dim);
    Inpainted = roifill(I, DilMask);

    %Elements not to be substituted (as they are badly eliminated by inpainting)
    Remaining = bwmorph(Mask,'erode',dim); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Given a binary image BWin, computes all its connected components (CCs)
%and returns the one that is:
%- big enough (area > MinArea)
%- wider, and
%- closer to the image center
%
function [BWout, DistOut] = ChooseCC(BWin, Title, show)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Adjustable parameter:
    MinArea  = 1200; %Minimum area of CCs to be considered
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Computes Area and Centroids of all CCs
    Labels = bwlabel(BWin);
    stats  = regionprops(Labels,'Centroid','Area');

    %Array of Centroids, one for each column
    Centroid = reshape([stats.Centroid], 2, size(stats,1));

    %Sorts CCs according to descending Area
    [Aord,iAord] = sort([stats.Area],'descend');

    %Selects only CCs that are not smaller than MinArea
    numCC = max([1,size(find(Aord>MinArea),2)]);

    %Computes distance from image center (Distance) for each CC
    ImgCenter  = [size(BWin,2)/2;size(BWin,1)/2];
    Distance = zeros(1,numCC);
    for j=1:numCC
        Distance(j) = norm(ImgCenter-Centroid(:,iAord(j)));
    end

    %Assigns positions in terms of Distance to each CC
    [Dord, iDord] = sort(Distance);

    %Computes average position (in terms of Area and Distance) for each CC
    MeanPosition=1:numCC; %Position in terms of Area
    for j=1:numCC
        %Add position in terms of Distance
        MeanPosition(iDord(j)) = MeanPosition(iDord(j)) + j;
    end
    MeanPosition=MeanPosition/2;

    %In case of equal avg position, selects the most centered CC (--> final)
    [OrdPos, iPord]=sort(MeanPosition);
    i=1; final=i;
    dmax = Distance(iPord(final));
    while ((i<numel(OrdPos)) && (OrdPos(i)==OrdPos(i+1)))
        if (dmax>Distance(iPord(i+1)))
            final = i+1;
            dmax = Distance(iPord(final));
        end
        i = i+1;
    end

    %Selects the final CC
    BWout = ismember(Labels,iAord(iPord(final)));
    DistOut = Distance(iPord(final));

    if (show)
        if strcmp(Title,'Rnorm')
            yposition=800;
        else
            yposition=300;
        end
        figure('Name',sprintf('Step 2-A: Choosing CC for %s',Title)); 
        nc=ceil(sqrt(numCC+3)); nr=ceil((numCC+3)/nc); i=1;
        subplot(nr,nc,i); i=i+1; imshow(BWin); title('Bin');
        subplot(nr,nc,i); i=i+1; imshow(label2rgb(Labels,'jet')); title('CCs in Bin');
        subplot(nr,nc,i); i=i+1; imshow(BWout);                   title('Chosen CC');
        for j=1:numCC
            CC = ismember(Labels,iAord(j));
            subplot(nr,nc,i); i=i+1; imshow(CC,[]); 
            title(sprintf('A = %d, d_C = %.2f',Aord(j), Distance(j)));
            hold on; plot(Centroid(1,iAord(j)),Centroid(2,iAord(j)),'r*');
            clear CC
        end
    end
    clear Labels stats Centroid Aord iAord Distance
    clear Dord iDord MeanPosition OrdPos iPord 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%imadjust of I taking into account only mask values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [IA] = imadjustROI(I,mask)
    maskv             = reshape(mask,1,numel(mask));
    IAv               = reshape(I,1,numel(I));
    ToBeIncluded      = find(maskv);
    IApart            = imadjust(IAv(ToBeIncluded));
    IAv(ToBeIncluded) = IApart;
    IA                = reshape(IAv,size(I,1),size(I,2));
    clear maskv IAv ToBeIncluded IApart
end