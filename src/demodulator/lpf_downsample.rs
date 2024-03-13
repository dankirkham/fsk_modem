use rust_hdl::prelude::*;

use crate::buffer::Buffer;
use crate::demodulator::decimator::Decimator;
use crate::fixed_point_round::FixedPointRound;
use crate::fir::RolledFir;

#[derive(LogicBlock)]
pub struct LpfDownsample {
    pub clock: Signal<In, Clock>,
    pub data_in: Signal<In, Signed<16>>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub strobe_out: Signal<Out, Bit>,
    fir: RolledFir<7>,
    downsample: Decimator<5>,
    fir_buffer: Buffer,
    output_round: FixedPointRound<48>,
}

impl Logic for LpfDownsample {
    #[hdl_gen]
    fn update(&mut self) {
        clock!(self, clock, fir, fir_buffer, output_round, downsample);

        self.fir.data_in.next = self.data_in.val();
        self.fir.strobe_in.next = self.strobe_in.val();

        self.output_round.data_in.next = self.fir.data_out.val();
        self.output_round.strobe_in.next = self.fir.strobe_out.val();

        self.fir_buffer.data_in.next = self.output_round.data_out.val();
        self.fir_buffer.strobe_in.next = self.output_round.strobe_out.val();

        self.downsample.data_in.next = self.fir_buffer.data_out.val();
        self.downsample.strobe_in.next = self.fir_buffer.strobe_out.val();

        self.data_out.next = self.downsample.data_out.val();
        self.strobe_out.next = self.downsample.strobe_out.val();
    }
}

impl Default for LpfDownsample {
    fn default() -> Self {
        let lpf_coeff = [
            -1790, -1093, -740, 226, 1754, 3594, 5361, 6638, 7103, 6638, 5361, 3594, 1754, 226,
            -740, -1093, -1790,
        ];
        Self {
            clock: Signal::default(),
            data_in: Signal::default(),
            data_out: Signal::default(),
            strobe_in: Signal::default(),
            strobe_out: Signal::default(),
            fir: RolledFir::new(&lpf_coeff),
            downsample: Decimator::new(4),
            fir_buffer: Buffer::default(),
            output_round: FixedPointRound::default(),
        }
    }
}
