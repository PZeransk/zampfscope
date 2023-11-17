#!/bin/bash

#[[ $- = *e* ]]; SAVED_OPT_E=$?
#set -e

(ffmpeg -y -v error -i zampf_proj.sim/sim_1/behav/xsim/image_out.ppm image_out.bmp)

ret_code=$?
if (($ret_code == 0))
then
  echo "conversion was successfull";
  echo 'image was saved to "./image_out.bmp"';
  exit 0;
fi

echo ''
echo 'Error occured during processing file with "ffmpeg"' >&2
echo 'check if you are in project home directory or'
echo 'install ffmpeg package with "sudo apt install ffmpeg"'

#(( $SAVED_OPT_E )) && set +e
exit $ret_code