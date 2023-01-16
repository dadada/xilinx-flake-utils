{ stdenvNoCC
, bash
, coreutils
, python3
, vitis
, lib
, makeWrapper
}: stdenvNoCC.mkDerivation {
  name = "xilinx-utils";
  src = ./.;
  buildInputs = [ coreutils python3 vitis ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out
    cp utils.sh $out/utils.sh

    mkdir $out/bin
    for command in restore generate-hw-config build-bootloader jtag-boot
    do
      echo "#/usr/bin/bash" >> $out/bin/$command
      echo "set +u" >> $out/bin/$command
      echo "source $out/utils.sh" >> $out/bin/$command
      echo "$command \"\$@\"" >> $out/bin/$command
      chmod +x $out/bin/$command
      wrapProgram $out/bin/$command --prefix PATH : ${lib.makeBinPath [ bash vitis python3 coreutils ]}
    done
  '';
}
