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
%   to be published in IEEE Journal of Biomedical and Health Informatics (2018), 
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
%Brings the mask BW1 back to original dimensions (adding Border)
%
function [BW] = BackToOriginal(BW1, I1, I2, Border)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BW2=I2;
BW2(1+Border(1):size(I2,1)-Border(2),1+Border(3):size(I2,2)-Border(4))=BW1;
BW2=BW2>0;
BW=imresize(BW2,[size(I1,1) size(I1,2)]);

