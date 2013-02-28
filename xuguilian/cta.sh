#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Usage:"
  echo "    cta.sh product_name product_flash modem_path"
  echo "Product:"
  echo "  msm7627a_d8 msm7627a_a8 msm7627a_v8 ..."
  echo "flash:"
  echo "  emmc or nand"
  echo "modem_path:"
  echo "  A9/Modem_A9_V0_05_20120620 ..."
  exit;
fi

project=$1        #Parameter 1

