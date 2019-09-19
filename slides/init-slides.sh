#!/bin/bash

# PARSE AND CHECK COMMAND-LINE ARGS
if [ "$#" -ne 1 ] 
then
	echo "Only one argument (presentation directory path) is accepted"
	exit 1
fi

# PATHS
SCRIPTDIR=`dirname "$0"`
LATEXDIR=`realpath "${SCRIPTDIR}/../latex-templates"`
TEMPLATE="${LATEXDIR}/presentation"
LANGDIR="${LATEXDIR}/langdefs"
PRESPATH=`realpath $1`
PRESNAME=`basename ${PRESPATH}`

# CHECK IF THE PRESENTATION DIRECTORY ALREADY EXISTS
if [ -d "$PRESPATH" ] 
then
	echo "Presentation at ${PRESPATH} already exists"
	exit 1
fi

# COPY FILES AND SET UP SYMLINKS
mkdir -p $PRESPATH
cp "${TEMPLATE}/presentation.tex" "${PRESPATH}/${PRESNAME}.tex"`
cp "${TEMPLATE}/slides.tex" "${PRESPATH}/."`
cp "${TEMPLATE}/literature.bib" "${PRESPATH}/${PRESNAME}.bib"`
cp "${TEMPLATE}/.gitignore" "${PRESPATH}/."`
ln -s `realpath --relative-to=${PRESPATH} ${LANGDIR}` "${PRESPATH}/."

# CHANGE BIBRESOURCE
sed -i 's@\(\\addbibresource{\)literature.bib\(}\)@\1'"$PRESNAME"'.bib\2@' "${PRESPATH}/${PRESNAME}.tex"

# FINISH
echo "Presentation at ${PRESPATH} created."
