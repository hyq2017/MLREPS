mkdir GLY-GLY
cd GLY-GLY
cp ../package/GLY/type.raw .
cp ../input.GLY-GLY .
cp ../package/GLY/energy_force.py .
python energy_force.py
mv *.log ../
cd ..
rm -rf GLY-GLY
