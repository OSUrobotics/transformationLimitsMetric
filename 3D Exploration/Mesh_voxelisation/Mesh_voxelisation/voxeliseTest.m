[v,f,no,na] = stlRead('PitcherAssm.stl')
fv.vertices = v
fv.faces = f
OUT = VOXELISE(25,50,25,fv,'xyz')
clf; 
hold on;
for i = 1:25
    for j = 1:50
        for k = 1:25
            if OUT(i,j,k) == 1
                scatter3(i,j,k,'.r');
            end
        end
    end
end
axis image