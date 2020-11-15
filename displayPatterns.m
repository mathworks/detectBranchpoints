A = [1 3 7;
1 3 9;
1 7 9;
3 7 9;
2 4 6;
2 4 8;
2 6 8;
4 6 8;
1 6 8;
3 4 8;
2 6 7;
2 4 9;
1 3 8;
1 6 7;
3 4 9;
2 7 9];
tiledlayout(4,4)
for ii = 1:size(A, 1)
nexttile
m = false(3);
m([5, A(ii, :)]) = true;
imshow(m)
end
set(gcf,'color',[0.5 0.5 0.5])