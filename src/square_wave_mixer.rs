use rust_hdl::prelude::*;

#[derive(Clone, Debug, LogicState, Copy, PartialEq)]
enum MixerState {
    Idle,
    Dwell,
    Compute,
    Done,
}

#[derive(LogicBlock)]
pub struct SquareWaveMixer {
    pub clock: Signal<In, Clock>,
    pub data_in_1: Signal<In, Signed<16>>,
    pub data_in_2: Signal<In, Signed<16>>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub strobe_out: Signal<Out, Bit>,
    data_1: DFF<Signed<16>>,
    data_2: DFF<Signed<16>>,
    state: DFF<MixerState>,
    one: Constant<Signed<16>>,
    max: Constant<Signed<16>>,
}

impl Logic for SquareWaveMixer {
    #[hdl_gen]
    fn update(&mut self) {
        dff_setup!(self, clock, data_1, data_2, state);

        if self.data_1.q.val().get_bit(15) ^ self.data_2.q.val().get_bit(15) {
            self.data_out.next = 0xffff.into();
        } else {
            self.data_out.next = 0x0000.into();
        }

        self.strobe_out.next = false;
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
                self.state.d.next = MixerState::Done;
            }
            MixerState::Done => {
                self.strobe_out.next = true;
                self.state.d.next = MixerState::Idle;
            }
        }
    }
}

impl Default for SquareWaveMixer {
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
            one: Constant::new(1.into()),
            max: Constant::new(0xffff.into()),
        }
    }
}
