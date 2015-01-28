function [position, genPosition] = calcSubplotDivPositions(nRows,nCols,nDivisions,...
    divProportion,plotNum,xOffset,yOffset,plotSpacing,divSpacing)
%calcSubplotDivPositions.m Function to determine positions for subplots
%within subplots (i.e. 4 x 4 matrix of suplots with 2 subplots in each)
%
%INPUTS
%nRows - number of plots on each side of the square
%nDivisions - number of vertical divisions within each subplot
%divProportions - 1 x nDivisions array containing proportions of plot size
%   (must add up to 1)
%plotNum - plot number columnwise to calculate positions for
%xOffset - optional 1 x 2 array of left and right xOffset as a fraction of
%   1
%yOffset - optional 1 x 2 array of bottom and top yOffset as a fraction of
%   1
%plotSpacing - optional 1 x 2 array of horizontal and vertical spacing
%   between plots
%divSpacing - optional scalar of vertical spacing between divisions
%
%OUTPUTS
%position - nDivisions x 4 array containing positions for each subplot in
%   normalized coordinates
%genPosition - 1 x 4 array of position of entire subplot (all divisions
%   included)
%
%ASM 11/13

%check for divSpacing, plotSpacing, xOffset, and yOffset
if nargin < 9 || isempty(divSpacing)
    divSpacing = 0.01;
end
if nargin < 8 || isempty(plotSpacing)
    plotSpacing = [0.025 0.025];
end
if nargin < 7 || isempty(yOffset)
    yOffset = [0.025 0.025];
end
if nargin < 6 || isempty(xOffset)
    xOffset = [0.025 0.025];
end

%ensure divProportions add up to 1 
if sum(divProportion) < 0.9999 || sum(divProportion) > 1.00001
    error('divProportion must add up to 1');
end

%ensure number of proportions equals number of divisions
if length(divProportion) ~= nDivisions
    error('divProportion must be same size as nDivisions');
end

%calculate total working x and y subplot area
totalX = 1 - sum(xOffset) - (nCols- 1)*plotSpacing(1);
totalY = 1 - sum(yOffset) - (nRows - 1)*plotSpacing(2);
plotWidth = totalX/nCols;
plotHeight = totalY/nRows;

%determine column and row of plot
[rowInd, colInd] = ind2sub([nRows nCols], plotNum);
rowInd = nRows - rowInd + 1;

%get left and bottom coordinates for general plot
leftCoord = xOffset(1) + (colInd-1)*(plotWidth + plotSpacing(1));
bottomCoord = yOffset(1) + (rowInd-1)*(plotHeight + plotSpacing(2));

%generate general position
genPosition = [leftCoord bottomCoord totalX totalY];

%calculate area available to divisions
totalDivHeight = plotHeight - (nDivisions-1)*divSpacing;
divHeights = divProportion*totalDivHeight;

%generate positions
position = zeros(nDivisions,4);
position(:,1) = leftCoord;
position(:,3) = plotWidth;
position(:,4) = divHeights';
position(1,2) = bottomCoord;
for i = 2:nDivisions
    position(i,2) = bottomCoord + sum(divHeights(1:i-1)) + (i-1)*divSpacing;
end
        
