{
  writeShellApplication,
  coreutils,
  gh,
  gnutar,
  ...
}:
writeShellApplication {
  name = "adv360";
  runtimeInputs = [coreutils gh gnutar];
  text = ''
    function download_firmware {
      mkdir -p ./firmware
      gh run download --repo willruggiano/Adv360-Pro-ZMK --dir ./firmware
    }

    function install_firmware {
      [ ! -e "./firmware/$1.uf2" ] && echo "Firmware not found: ./firmware/$1.uf2" && exit 1

      while [ ! -e /dev/sda ]; do
        echo '/dev/sda not yet available...'
        sleep 1s
      done

      sudo mount /dev/sda /mnt/adv360
      sudo cp -v "./firmware/$1.uf2" /mnt/adv360
      sudo umount /dev/sda

      while [ -e /dev/sda ]; do
        echo '/dev/sda still available...'
        sleep 1s
      done
    }

    case "$1" in
      download)
        download_firmware
        ;;
      install)
        install_firmware "$2"
        ;;
      clean)
        rm -v ./firmware/*.uf2
        ;;
      help)
        echo "Usage: adv360 download|install|clean [left|right]"
        exit 1
        ;;
    esac
  '';
}
