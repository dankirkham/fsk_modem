use rtl_dds::bsp::synth;
use rtl_dds::modem::Modem;

fn main() {
    let uut = Modem::default();

    synth::generate_bitstream(uut, "firmware/dds")
}
