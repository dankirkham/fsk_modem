use rust_hdl::prelude::*;

use crate::fixed_point_round::FixedPointRound;

#[derive(Clone, Debug, LogicState, Copy, PartialEq)]
enum MixerState {
    Idle,
    Dwell,
    Compute,
    Round,
    Done,
}

#[derive(LogicBlock)]
pub struct Mixer {
    pub clock: Signal<In, Clock>,
    pub data_in_1: Signal<In, Signed<16>>,
    pub data_in_2: Signal<In, Signed<16>>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub strobe_out: Signal<Out, Bit>,
    data_1: DFF<Signed<16>>,
    data_2: DFF<Signed<16>>,
    output_round: FixedPointRound<32>,
    state: DFF<MixerState>,
}

impl Logic for Mixer {
    #[hdl_gen]
    fn update(&mut self) {
        clock!(self, clock, output_round);
        dff_setup!(self, clock, data_1, data_2, state);

        self.output_round.data_in.next = self.data_1.q.val() * self.data_2.q.val();
        self.data_out.next = self.output_round.data_out.val();

        self.strobe_out.next = false;
        self.output_round.strobe_in.next = false;
        match self.state.q.val() {
            MixerState::Idle => {
                if self.strobe_in.val() {
                    self.data_1.d.next = self.data_in_1.val();
                    self.data_2.d.next = self.data_in_2.val();

                    self.state.d.next = MixerState::Dwell;
                }
            }
            MixerState::Dwell => {
                self.state.d.next = MixerState::Compute;
            }
            MixerState::Compute => {
                self.state.d.next = MixerState::Round;
            }
            MixerState::Round => {
                self.output_round.strobe_in.next = true;
                self.state.d.next = MixerState::Done;
            }
            MixerState::Done => {
                self.strobe_out.next = true;
                self.state.d.next = MixerState::Idle;
            }
        }
    }
}

impl Default for Mixer {
    fn default() -> Self {
        Self {
            clock: Signal::default(),
            data_in_1: Signal::default(),
            data_in_2: Signal::default(),
            data_out: Signal::default(),
            strobe_in: Signal::default(),
            strobe_out: Signal::default(),
            data_1: DFF::default(),
            data_2: DFF::default(),
            state: DFF::default(),
            output_round: FixedPointRound::default(),
        }
    }
}
