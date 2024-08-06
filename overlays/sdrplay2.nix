final: prev: {
    # Override to include sopaysdrplay2
    soapysdr-with-plugins =  prev.soapysdr.override {
        extraPackages = with prev; [
            limesuite
            soapyairspy
            soapyaudio
            soapybladerf
            soapyhackrf
            soapyremote
            soapyrtlsdr
            soapysdrplay2
            soapyuhd
        ];
    };
} // import ./. final prev