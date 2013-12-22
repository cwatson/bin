#! /bin/bash
#
# Rename and convert the old functional datasets for the LDProj that was pulled
# off the Jaz drive.
#

. /raid2/apps/freesurfer/current/SetUpFreeSurfer.sh

if [[ ! -d "new_func" ]]; then
    mkdir new_func
fi
if [[ ! -d "bold" ]]; then
    mkdir bold
fi

# Rename images and put into a new dir.
ls I.* | python /occipital/dnl_library/bin/jazrename.py - | sh

# Make directories for each image volume.
cd new_func
python /occipital/dnl_library/bin/jazmkdir.py | sh

# Put every x images (x slices = 1 volume) to each dir.
for i in `seq 1 400`
do
    for f in `ls I.* | head -20`
    do
        mv $f volume${i}/
    done
done

# Rename images to something mri_convert likes.
find . -name "I.*" | python /occipital/dnl_library/bin/jazrename2.py - | sh

for d in `find . -type d -name "volume*"`
do
    cd $d
    mri_convert -i `ls I.* | head -1` -it ge -iis 4.69 -ijs 4.69 -iks 7 -iid -1 0 0 -ijd 0 -1 0 -ikd 0 0 1 -ic 0 0 0 -ot analyze "image"
    cd -
done

# Rename images that are in analyze format to put into SPM.
ls -d volume* | python /occipital/dnl_library/bin/jazrename3.py - | sh

cd ..
for f in `find . -name "image*"`
do
    mv $f bold/
done
