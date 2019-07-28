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
%Creates a binary mask (Bout) of size RxC whose corners are white. 
%The size of the corners is R/q.
%
function [Bout]=createCorners(R,C,q)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    B=zeros(R,C);
    lim=floor(R/q);
    %Upper left corner
    for i=1:lim
        for j=1:lim-i
            B(i,j)=1;
        end
    end
    %Bottom left corner
    for i=size(B,1)-lim:size(B,1)
        for j=1:i-size(B,1)+lim
            B(i,j)=1;
        end
    end
    %Upper right corner
    for i=1:lim
        for j=size(B,2)-lim+i:size(B,2)
            B(i,j)=1;
        end
    end
    %Bottom right corner
    for i=size(B,1)-lim:size(B,1)
        for j=size(B,2)-i+size(B,1)-lim:size(B,2)
            B(i,j)=1;
        end
    end
    Bout=B>0;
    
    clear B
end