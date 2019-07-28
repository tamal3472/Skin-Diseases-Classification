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
%Applies post-processing to mask BW1, returning the result in BW
%
function [BW] = Step3_PostProcess(BWinit, show)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Adjustable parameter:
    DilFactor = 7;

    %Morphological dilation
    BW1 = bwmorph(BWinit,'dilate',DilFactor);
    
    %Extracts the convex hull of widest CC in BW1 (--> BW)
    stats = regionprops(BW1,'Area','BoundingBox','ConvexImage');
    [y,idx] = max([stats.Area]);
    BB = [stats(idx).BoundingBox];
    BW = BW1<0;
    BW(round(BB(2)):round(BB(2)+BB(4)-1),round(BB(1)):round(BB(1)+BB(3)-1))=...
        stats(idx).ConvexImage;

    if (show)
        figure('Name','Step 3: Post-processing','Position'); nr=1; nc=2; i=1;
        subplot(nr,nc,i); i=i+1; imshow(BWinit); title('Initial Segmentation');
        subplot(nr,nc,i);        imshow(BW);     title('Final Segmentation');
    end
    clear BW1 stats y idx BB
