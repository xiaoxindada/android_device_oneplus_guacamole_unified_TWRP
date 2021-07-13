#!/system/bin/sh

relink()
{
	fname=$(basename "$1")
	target="/sbin/$fname"
	sed 's|/system/bin/linker64|///////sbin/linker64|' "$1" > "$target"
	chmod 755 $target
}

finish()
{
	umount /v
	umount /s
	rmdir /v
	rmdir /s
	setprop crypto.ready 1
	exit 0
}

suffix=$(getprop ro.boot.slot_suffix)
if [ -z "$suffix" ]; then
	suf=$(getprop ro.boot.slot)
	suffix="_$suf"
fi
venpath="/dev/block/bootdevice/by-name/vendor$suffix"
mkdir /v
mount -t ext4 -o ro "$venpath" /v
syspath="/dev/block/bootdevice/by-name/system$suffix"
mkdir /s
mount -t ext4 -o ro "$syspath" /s

device_codename=$(getprop ro.boot.hardware)
is_fastboot_twrp=$(getprop ro.boot.fastboot)

###### NOTE: The below is no longer used but I'm keeping it here in case it is needed again at some point!
mkdir -p /vendor/lib64/hw/

cp /s/system/lib64/android.hidl.base@1.0.so /sbin/
cp /s/system/lib64/libicuuc.so /sbin/
cp /s/system/lib64/libxml2.so /sbin/

relink /v/bin/qseecomd

cp /v/lib64/libdiag.so /vendor/lib64/
cp /v/lib64/libdrmfs.so /vendor/lib64/
cp /v/lib64/libdrmtime.so /vendor/lib64/
cp /v/lib64/libGPreqcancel.so /vendor/lib64/
cp /v/lib64/libGPreqcancel_svc.so /vendor/lib64/
cp /v/lib64/libqdutils.so /vendor/lib64/
cp /v/lib64/libqisl.so /vendor/lib64/
cp /v/lib64/libqservice.so /vendor/lib64/
cp /v/lib64/libQSEEComAPI.so /vendor/lib64/
cp /v/lib64/librecovery_updater_msm.so /vendor/lib64/
cp /v/lib64/librpmb.so /vendor/lib64/
cp /v/lib64/libsecureui.so /vendor/lib64/
cp /v/lib64/libSecureUILib.so /vendor/lib64/
cp /v/lib64/libsecureui_svcsock.so /vendor/lib64/
cp /v/lib64/libspcom.so /vendor/lib64/
cp /v/lib64/libspl.so /vendor/lib64/
cp /v/lib64/libssd.so /vendor/lib64/
cp /v/lib64/libStDrvInt.so /vendor/lib64/
cp /v/lib64/libtime_genoff.so /vendor/lib64/
cp /v/lib64/libkeymasterdeviceutils.so /vendor/lib64/
cp /v/lib64/libkeymasterprovision.so /vendor/lib64/
cp /v/lib64/libkeymasterutils.so /vendor/lib64/
cp /v/lib64/libqtikeymaster4.so /vendor/lib64/
cp /v/lib64/vendor.qti.hardware.tui_comm@1.0.so /vendor/lib64/
cp /v/lib64/hw/bootctrl.sdm845.so /vendor/lib64/hw/
cp /v/lib64/hw/android.hardware.boot@1.0-impl.so /vendor/lib64/hw/
cp /v/lib64/hw/android.hardware.gatekeeper@1.0-impl-qti.so /vendor/lib64/hw/

cp /v/manifest.xml /vendor/
cp /v/compatibility_matrix.xml /vendor/

relink /v/bin/hw/android.hardware.boot@1.0-service
relink /v/bin/hw/android.hardware.gatekeeper@1.0-service-qti
relink /v/bin/hw/android.hardware.keymaster@4.0-service-qti

finish
exit 0
