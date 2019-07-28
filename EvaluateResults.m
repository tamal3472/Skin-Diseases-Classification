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
%Evaluates dermoscopic image segmentation results against the ISIC 2017
%ground truth masks
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input and output data (to be adapted)
DirImages  = '../Images/ISIC2017/Test_v2_Data/'; %Directory including input images
DirGTs     = '../Images/ISIC2017/Test_v2_Part1_GroundTruth/'; %Directory including GT maskss
DirResults = './TestResults/'; %Directory including computed masks
OutputMat  = 'TestResults.mat';%.mat file including performance results
show       = 0; %To show the results (Avoid to use it with ALL results)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
JPG='*.jpg';%All (input) .jpg images
PNG='*.png';%All (computed) .png results

nameCR  = strcat(DirResults,PNG);
ListaCR = dir(nameCR);
nameIm  = strcat(DirImages,JPG); 
nameGT  = strcat(DirGTs,PNG); 
ListaIm = dir(nameIm);

NumberOfImages=min(size(ListaIm,1),size(ListaCR,1)); 

%Initialization
AC = zeros(NumberOfImages,1); SE = AC; SP = AC; DI = AC; JA = AC;

tic
for number=1:NumberOfImages
    nameIm = strcat(DirImages,cat(1,ListaIm(number).name));
    radix  = nameIm(length(nameIm)-15:length(nameIm)-4);
    nameGT = strcat(DirGTs,radix,'_Segmentation.png');
    nameCR = strcat(DirResults,radix,'_Segmentation.png');

    GT = imread(nameGT);
    CR = imread(nameCR)>0;
        
    TP = GT&CR;       nTP = sum(TP(:));
    FP = (~GT)&CR;    nFP = sum(FP(:));
    FN = GT&(~CR);    nFN = sum(FN(:));
    TN = (~GT)&(~CR); nTN = sum(TN(:));
    AC(number) = (nTP+nTN)/(nTP+nFP+nTN+nFN);
    SE(number) = (nTP)/(nTP+nFN);
    SP(number) = (nTN)/(nTN+nFP);
    DI(number) = 2*nTP/(2*nTP+nFN+nFP);
    JA(number) = nTP/(nTP+nFN+nFP);
    
    if (show)
        I1=imread(nameIm);
        figure; 
        subplot(2,3,1); imshow(I1); title('Input image');
        subplot(2,3,2); imshow(GT); title('GT Mask');
        subplot(2,3,3); imshow(CR); title(strcat('Computed result (JA=',num2str(JA(number)),')'));
        subplot(2,3,4); imshow(TP); title('TPs');
        subplot(2,3,5); imshow(FP); title('FPs');
        subplot(2,3,6); imshow(FN); title('FN');
        clear I1
    end
    clear GT CR
end 
toc
fprintf('Average AC = %f\n',mean(AC));
fprintf('Average SE = %f\n',mean(SE));
fprintf('Average SP = %f\n',mean(SP));
fprintf('Average DI = %f\n',mean(DI));
fprintf('Average JA = %f\n',mean(JA));

save(OutputMat,'AC','SE','SP','DI','JA');
