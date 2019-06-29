#!/bin/bash
# Simple script to rename MP3 of FLAC files by their id3 tags

if [[ $# -lt 1 ]]; then
    echo "Please provide a file!"
    exit 1
fi

# Convert any spaces in the filename to underscores
newf=${1}
file_ext=${newf##*.}
pattern=" |'"
if [[ ${1} =~ ${pattern} ]]; then
    ff=$(echo ${1} | sed 's/\s/_/g' | sed "s/'//g")
    mv "${1}" "${ff}"
    newf=${ff}
fi

# Remove spaces, single quotes, leading track numbers, and extraneous info
# Also, convert articles to lowercase if they are not at the start of the string
sed_args="
s/^\s//
s/\s$//
s/[0-9][0-9]\(\s\|_\)-\(\s\|_\)//
s/\(_\|\s\)Of\(_\|\s\)/ of /g
s/\(_\|\s\)To\(_\|\s\)/ to /g
s/\(_\|\s\)In\(_\|\s\)/ in /g
s/\(_\|\s\)The\(_\|\s\)/ the /g
s/\(_\|\s\)And\(_\|\s\)/ and /g
s/\(_\|\s\)With\(_\|\s\)/ with /g
s/\(_\|\s\)A\(_\|\s\)/ a /g
s/\s/_/g
s/'//g
s/_\(\[\|(\)[Bb]onus[[:graph:]]*\(\]\|)\)//
s/_\(\[\|(\)[Jj]apan[[:graph:]]*\(\]\|)\)//
s/_\(\[\|(\)[Rr]e-issue\(\]\|)\)//
s/_\(\[\|(\)[Rr]eissue\(\]\|)\)//
s/-amrc//
"

if [[ ${file_ext} == mp3 ]]; then
    artist=$(id3info ${newf} | grep -E 'TPE1|TP1' | cut -d: -f2 | sed -e "${sed_args}")
    if [[ -z ${artist} ]]; then
        echo "No artist tag present; please create one with 'id3tag -a'"
        exit 2
    fi
    album=$(id3info ${newf} | grep -E 'TALB|TAL' | cut -d: -f2 | sed -e "${sed_args}")
    if [[ -z ${album} ]]; then
        echo "No album tag present; please create one with 'id3tag -A'"
        exit 3
    fi

    #-------------------------------------------------------------------------------
    # Handle the track number
    #-------------------------------------------------------------------------------
    track=$(id3info ${newf} | grep -E 'TRCK|TRK' | cut -d: -f2 | cut -d/ -f1 | sed 's/\s//')
    # If there is no track tag, see if it's in the filename
    if [[ -z ${track} ]]; then
        track=$(echo "${1}" | grep -oE '\<[0-9][0-9]\>|_[0-9][0-9]_' | sed 's/_//g')
        if [[ -z ${track} ]]; then
            track=00
        else
            id3tag -t "${track}" "${newf}"
        fi
    fi

    #-------------------------------------------------------------------------------
    # Handle the track title
    #-------------------------------------------------------------------------------
    trackNumStart=".*\(\[\)\?[0-9][0-9]\(\]\)\?\(\s\|_\)\(-\)\?\(\s\|_\)\?"
    title=$(id3info ${newf} | grep -E 'TIT2|TT2' | cut -d: -f2 | sed -e "${sed_args}")
    # Remove any leading characters, plus track numbers (possibly in brackets) separated by space or underscore
    title=$(echo "${title}" | sed "s/$trackNumStart//")

    # If there is no title, see if it's in the filename
    if [[ -z ${title} ]]; then
        tt=$(basename "${1}" .mp3 | sed -n 's/[[:graph:]]*\(\[\)\?[0-9][0-9]\(\]\)\?\(\s\|_\)\(-\)\?\(\s\|_\)\?//p')
        # If the year is in the filename, then remove it first
        tt=$(echo "${tt}" | sed 's/([0-9]*)//' | sed 's/\s$//')
        if [[ -n ${tt} ]]; then
            id3tag -s "${tt}" "${newf}"
            tt=$(echo "${tt}" | sed -e "${sed_args}")
            title="${tt}"
        else
            title=XXX
        fi
    fi

elif [[ ${file_ext} == flac ]]; then
    artist=$(metaflac --show-tag=ARTIST ${newf} | cut -d= -f2 | sed -e "${sed_args}")
    album=$(metaflac --show-tag=ALBUM ${newf} | cut -d= -f2 | sed -e "${sed_args}")
    track=$(metaflac --show-tag=TRACKNUMBER ${newf} | cut -d= -f2 | sed 's/\s//')
    title=$(metaflac --show-tag=TITLE ${newf} | cut -d= -f2 | sed -e "${sed_args}")
fi

[[ ${#track} -lt 2 ]] && printf -v track "%02d" ${track}
mv "${newf}" "${artist}"_-_"${album}"_-_"${track}"_"${title}".${file_ext}
