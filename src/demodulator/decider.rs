use rust_hdl::prelude::*;

#[derive(LogicBlock)]
pub struct Decider {
    pub clock: Signal<In, Clock>,
    pub space_data_in: Signal<In, Signed<16>>,
    pub space_strobe_in: Signal<In, Bit>,
    pub mark_data_in: Signal<In, Signed<16>>,
    pub mark_strobe_in: Signal<In, Bit>,
    pub mark_out: Signal<Out, Bit>,

    mark_data_ready: DFF<Bit>,
    mark_data_staged: DFF<Signed<16>>,

    space_data_ready: DFF<Bit>,
    space_data_staged: DFF<Signed<16>>,

    mark_data: DFF<Signed<16>>,
    space_data: DFF<Signed<16>>,

    mark: DFF<Bit>,
}

impl Logic for Decider {
    #[hdl_gen]
    fn update(&mut self) {
        dff_setup!(
            self,
            clock,
            mark_data_ready,
            mark_data_staged,
            space_data_ready,
            space_data_staged,
            mark_data,
            space_data,
            mark
        );

        self.mark_out.next = self.mark.q.val();

        if self.space_strobe_in.val() {
            self.space_data_staged.d.next = self.space_data_in.val();
            self.space_data_ready.d.next = true;
        }

        if self.mark_strobe_in.val() {
            self.mark_data_staged.d.next = self.mark_data_in.val();
            self.mark_data_ready.d.next = true;
        }

        if self.space_data_ready.q.val() && self.mark_data_ready.q.val() {
            self.space_data_ready.d.next = false;
            self.space_data.d.next = self.space_data_staged.q.val();

            self.mark_data_ready.d.next = false;
            self.mark_data.d.next = self.mark_data_staged.q.val();
        }

        self.mark.d.next = self.mark_data.q.val() > self.space_data.q.val();
    }
}

impl Default for Decider {
    fn default() -> Self {
        Self {
            clock: Signal::default(),
            mark_data_in: Signal::default(),
            mark_strobe_in: Signal::default(),
            space_data_in: Signal::default(),
            space_strobe_in: Signal::default(),
            mark_out: Signal::default(),
            mark_data_ready: DFF::default(),
            space_data_ready: DFF::default(),
            mark_data_staged: DFF::default(),
            space_data_staged: DFF::default(),
            mark_data: DFF::default(),
            space_data: DFF::default(),
            mark: DFF::default(),
        }
    }
}
