use array_init::array_init;
use rust_hdl::prelude::*;

#[derive(LogicBlock)]
pub struct MovingAverage<const N: usize> {
    pub clock: Signal<In, Clock>,
    pub data_in: Signal<In, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_out: Signal<Out, Bit>,
    state: [DFF<Signed<16>>; N],
    data: DFF<Signed<16>>,
    calc: DFF<Bit>,
    calc_w: Signal<Local, Signed<16>>,
    strobe: DFF<Bit>,
}

impl<const N: usize> Logic for MovingAverage<N> {
    #[hdl_gen]
    fn update(&mut self) {
        dff_setup!(self, clock, data, calc, strobe);
        for i in 0..N {
            self.state[i].clock.next = self.clock.val();
            self.state[i].d.next = self.state[i].q.val();
        }

        self.strobe_out.next = self.strobe.q.val();
        self.data_out.next = self.data.q.val();

        if self.strobe_in.val() {
            self.state[0].d.next = self.data_in.val();
            for i in 1..N {
                self.state[i].d.next = self.state[i - 1].q.val();
            }
            self.calc.d.next = true;
        } else {
            self.calc.d.next = false;
        }

        if self.calc.q.val() {
            self.calc_w.next = 0.into();
            self.calc_w.next = self.state[0].q.val().get_bits::<16>(4)
                + self.state[1].q.val().get_bits::<16>(4)
                + self.state[2].q.val().get_bits::<16>(4)
                + self.state[3].q.val().get_bits::<16>(4)
                + self.state[4].q.val().get_bits::<16>(4)
                + self.state[5].q.val().get_bits::<16>(4)
                + self.state[6].q.val().get_bits::<16>(4)
                + self.state[7].q.val().get_bits::<16>(4)
                + self.state[8].q.val().get_bits::<16>(4)
                + self.state[9].q.val().get_bits::<16>(4)
                + self.state[10].q.val().get_bits::<16>(4)
                + self.state[11].q.val().get_bits::<16>(4)
                + self.state[12].q.val().get_bits::<16>(4)
                + self.state[13].q.val().get_bits::<16>(4)
                + self.state[14].q.val().get_bits::<16>(4)
                + self.state[15].q.val().get_bits::<16>(4);

            self.data.d.next = self.calc_w.val();

            self.strobe.d.next = true;
        } else {
            self.strobe.d.next = false;
        }
    }
}

impl<const N: usize> Default for MovingAverage<N> {
    fn default() -> Self {
        assert_eq!(N, 16);
        Self {
            clock: Signal::default(),
            data_in: Signal::default(),
            strobe_in: Signal::default(),
            data_out: Signal::default(),
            strobe_out: Signal::default(),
            state: array_init(|_| Default::default()),
            data: DFF::default(),
            calc: DFF::default(),
            calc_w: Signal::default(),
            strobe: DFF::default(),
        }
    }
}
