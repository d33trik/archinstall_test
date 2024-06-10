pacman -S --noconfirm --needed pulseaudio pulseaudio-alsa pulseaudio-jack pavucontrol
cat <<EOF >> /etc/pulse/default.pa.d/noise-cancellation.pa
### Enable Echo/Noise-Cancellation
load-module module-echo-cancel use_master_format=1 aec_method=webrtc aec_args=\"analog_gain_control=0 digital_gain_control=1\" source_name=echoCancel_source sink_name=echoCancel_sink
set-default-source echoCancel_source
set-default-sink echoCancel_sink
EOF
pulseaudio -k
pulseaudio --start
