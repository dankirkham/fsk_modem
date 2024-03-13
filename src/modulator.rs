use rust_hdl::prelude::*;

use crate::bsp::pins;
use crate::buffer::Buffer;
use crate::dds::DDS24_8;

#[derive(LogicBlock)]
pub struct Modulator {
    pub clock: Signal<In, Clock>,
    pub mark_in: Signal<In, Bit>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_out: Signal<Out, Bit>,
    dds: DDS24_8,
    // lpf: RolledFir<6>,
    mark: DFF<Bit>,
    // lpf_buffer: Buffer,
}

impl Logic for Modulator {
    #[hdl_gen]
    fn update(&mut self) {
        clock!(self, clock, dds);
        dff_setup!(self, clock, mark);

        self.mark.d.next = self.mark_in.val();
        self.dds.mark.next = self.mark.q.val();

        // self.lpf.data_in.next = self.dds.data_out.val();
        // self.lpf.strobe_in.next = self.dds.strobe_out.val();

        // self.lpf_buffer.data_in.next = self.lpf.data_out.val().get_bits::<16>(16);
        // self.lpf_buffer.strobe_in.next = self.lpf.strobe_out.val();

        // self.lpf_buffer.data_in.next = self.lpf.data_out.val().get_bits::<16>(16);
        // self.lpf_buffer.strobe_in.next = self.lpf.strobe_out.val();

        // self.data_out.next = self.lpf_buffer.data_out.val();
        // self.strobe_out.next = self.lpf_buffer.strobe_out.val();

        self.data_out.next = self.dds.data_out.val();
        self.strobe_out.next = self.dds.strobe_out.val();
    }
}

impl Default for Modulator {
    fn default() -> Self {
        // let coeff = [
        //     249, 564, 462, -562, -2139, -2740, -718, 3938, 8922, 11073, 8922, 3938, -718, -2740,
        //     -2139, -562, 462, 564, 249,
        // ];
        Self {
            clock: pins::clock(),
            mark_in: Signal::default(),
            strobe_out: Signal::default(),
            data_out: Signal::default(),
            dds: DDS24_8::new(2_214_592, 2_147_483),
            // lpf: RolledFir::new(&coeff),
            mark: DFF::default(),
            // lpf_buffer: Buffer::default(),
        }
    }
}
