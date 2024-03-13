mod abs;
mod decider;
mod decimator;
mod lpf_downsample;
mod single_pole_recursive_lpf;
mod symbol_pipeline;

use rust_hdl::prelude::*;

use crate::dds::DDS24_8;
use crate::mixer::Mixer;
use crate::square_wave_mixer::SquareWaveMixer;

use self::decider::Decider;
use self::lpf_downsample::LpfDownsample;
use self::symbol_pipeline::SymbolPipeline;

#[derive(LogicBlock)]
pub struct Demodulator {
    pub clock: Signal<In, Clock>,
    pub data_in: Signal<In, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub mark_out: Signal<Out, Bit>,
    lo: DDS24_8,
    mixer: Mixer,
    lpf_down_1: LpfDownsample,
    lpf_down_2: LpfDownsample,
    space_pipeline: SymbolPipeline,
    mark_pipeline: SymbolPipeline,
    decider: Decider,
}

impl Logic for Demodulator {
    #[hdl_gen]
    fn update(&mut self) {
        // dff_setup!(self, clock);
        clock!(
            self,
            clock,
            lo,
            mixer,
            lpf_down_1,
            lpf_down_2,
            space_pipeline,
            mark_pipeline,
            decider
        );

        self.lo.mark.next = false;

        self.mixer.data_in_1.next = self.data_in.val();
        self.mixer.data_in_2.next = self.lo.data_out.val();
        self.mixer.strobe_in.next = self.strobe_in.val();

        self.lpf_down_1.data_in.next = self.mixer.data_out.val();
        self.lpf_down_1.strobe_in.next = self.mixer.strobe_out.val();

        self.lpf_down_2.data_in.next = self.lpf_down_1.data_out.val();
        self.lpf_down_2.strobe_in.next = self.lpf_down_1.strobe_out.val();

        self.space_pipeline.data_in.next = self.lpf_down_2.data_out.val();
        self.space_pipeline.strobe_in.next = self.lpf_down_2.strobe_out.val();

        self.mark_pipeline.data_in.next = self.lpf_down_2.data_out.val();
        self.mark_pipeline.strobe_in.next = self.lpf_down_2.strobe_out.val();

        self.decider.space_data_in.next = self.space_pipeline.data_out.val();
        self.decider.space_strobe_in.next = self.space_pipeline.strobe_out.val();

        self.decider.mark_data_in.next = self.mark_pipeline.data_out.val();
        self.decider.mark_strobe_in.next = self.mark_pipeline.strobe_out.val();

        self.mark_out.next = self.decider.mark_out.val();
    }
}

impl Default for Demodulator {
    fn default() -> Self {
        let space = [
            3282, -7600, -4068, -2376, -919, 559, 1705, 2133, 1705, 559, -919, -2376, -4068, -7600,
            3282,
        ];

        // HPF
        let mark = [
            -2857, 2073, 2905, 3169, 1906, -1043, -4854, -8070, 23442, -8070, -4854, -1043, 1906,
            3169, 2905, 2073, -2857,
        ];

        Self {
            clock: Signal::default(),
            data_in: Signal::default(),
            strobe_in: Signal::default(),
            mark_out: Signal::default(),
            lo: DDS24_8::new(2_042_626, 2_042_626),
            mixer: Mixer::default(),
            lpf_down_1: LpfDownsample::default(),
            lpf_down_2: LpfDownsample::default(),
            space_pipeline: SymbolPipeline::new(&space),
            mark_pipeline: SymbolPipeline::new(&mark),
            decider: Decider::default(),
        }
    }
}
