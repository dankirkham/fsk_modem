use rust_hdl::prelude::*;

use crate::buffer::Buffer;
use crate::demodulator::abs::Abs;
use crate::fir::RolledFir;
use crate::fixed_point_round::FixedPointRound;

// use super::single_pole_recursive_lpf::SinglePoleRecursiveLPF;

#[derive(LogicBlock)]
pub struct SymbolPipeline {
    pub clock: Signal<In, Clock>,
    pub data_in: Signal<In, Signed<16>>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub strobe_out: Signal<Out, Bit>,
    fir: RolledFir<7>,
    fir_round: FixedPointRound<48>,
    envelope_filter: RolledFir<5>,
    abs: Abs,
    fir_buffer: Buffer,
    env_buffer: Buffer,
    abs_buffer: Buffer,
}

impl Logic for SymbolPipeline {
    #[hdl_gen]
    fn update(&mut self) {
        clock!(
            self,
            clock,
            fir,
            fir_buffer,
            envelope_filter,
            abs,
            env_buffer,
            fir_round,
            abs_buffer
        );

        self.fir.data_in.next = self.data_in.val();
        self.fir.strobe_in.next = self.strobe_in.val();

        self.fir_round.data_in.next = self.fir.data_out.val();
        self.fir_round.strobe_in.next = self.fir.strobe_out.val();

        self.fir_buffer.data_in.next = self.fir_round.data_out.val();
        self.fir_buffer.strobe_in.next = self.fir_round.strobe_out.val();

        self.abs.data_in.next = self.fir_buffer.data_out.val();
        self.abs.strobe_in.next = self.fir_buffer.strobe_out.val();

        self.abs_buffer.data_in.next = self.abs.data_out.val();
        self.abs_buffer.strobe_in.next = self.abs.strobe_out.val();

        self.envelope_filter.data_in.next = self.abs_buffer.data_out.val();
        self.envelope_filter.strobe_in.next = self.abs_buffer.strobe_out.val();

        self.env_buffer.data_in.next = self.envelope_filter.data_out.val().get_bits::<16>(20);
        self.env_buffer.strobe_in.next = self.envelope_filter.strobe_out.val();

        self.data_out.next = self.env_buffer.data_out.val();
        self.strobe_out.next = self.env_buffer.strobe_out.val();
    }
}

impl SymbolPipeline {
    pub fn new(coeff: &[i16]) -> Self {
        let env_coeff = [
            -2326, 1281, 1887, 2793, 3794, 4688, 5304, 5523, 5304, 4688, 3794, 2793, 1887, 1281,
            -2326,
        ];
        Self {
            clock: Signal::default(),
            data_in: Signal::default(),
            data_out: Signal::default(),
            strobe_in: Signal::default(),
            strobe_out: Signal::default(),
            fir: RolledFir::new(coeff),
            fir_round: FixedPointRound::default(),
            envelope_filter: RolledFir::new(
                &env_coeff,
            ),
            // envelope_filter: MovingAverage::default(),
            // envelope_filter: SinglePoleRecursiveLPF::default(),
            abs: Abs::default(),
            fir_buffer: Buffer::default(),
            env_buffer: Buffer::default(),
            abs_buffer: Buffer::default(),
        }
    }
}
