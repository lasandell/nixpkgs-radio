final: prev: {
    # Override to include sopaysdrplay
    soapysdr-with-plugins =  prev.soapysdr.override {
        extraPackages = with prev; [
            limesuite
            soapyairspy
            soapyaudio
            soapybladerf
            soapyhackrf
            soapyremote
            soapyrtlsdr
            soapysdrplay
            soapyuhd
        ];
    };
} // import ./. final prev