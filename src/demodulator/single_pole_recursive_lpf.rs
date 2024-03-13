use rust_hdl::prelude::*;

use crate::mac::MAC;

#[derive(LogicBlock)]
pub struct SinglePoleRecursiveLPF {
    pub clock: Signal<In, Clock>,
    pub data_in: Signal<In, Signed<16>>,
    pub strobe_in: Signal<In, Bit>,
    pub data_out: Signal<Out, Signed<16>>,
    pub strobe_out: Signal<Out, Bit>,
    x_0: DFF<Signed<16>>,
    y_n1: DFF<Signed<16>>,
    calc: DFF<Bit>,
    strobe: DFF<Bit>,
    mac_a0: MAC,
    mac_b1: MAC,
    a_0: Constant<Signed<16>>,
    b_1: Constant<Signed<16>>,
}

impl Logic for SinglePoleRecursiveLPF {
    #[hdl_gen]
    fn update(&mut self) {
        clock!(self, clock, mac_a0, mac_b1);
        dff_setup!(self, clock, x_0, y_n1, calc, strobe);

        self.strobe_out.next = self.strobe.q.val();
        self.data_out.next = self.y_n1.q.val();

        if self.strobe_in.val() {
            self.x_0.d.next = self.data_in.val();
            self.calc.d.next = true;
        } else {
            self.calc.d.next = false;
        }

        self.mac_a0.a.next = self.x_0.q.val();
        self.mac_a0.b.next = self.a_0.val();
        self.mac_a0.c.next = 0.into();

        self.mac_b1.a.next = self.y_n1.q.val();
        self.mac_b1.b.next = self.b_1.val();
        self.mac_b1.c.next = 0.into();

        if self.calc.q.val() {
            self.y_n1.d.next = self.mac_a0.prod.val().get_bits::<16>(16)
                + self.mac_b1.prod.val().get_bits::<16>(16);
            self.strobe.d.next = true;
        } else {
            self.strobe.d.next = false;
        }
    }
}

impl Default for SinglePoleRecursiveLPF {
    fn default() -> Self {
        let alpha = 0x0ccd;
        Self {
            clock: Signal::default(),
            data_in: Signal::default(),
            strobe_in: Signal::default(),
            data_out: Signal::default(),
            strobe_out: Signal::default(),
            x_0: DFF::default(),
            y_n1: DFF::default(),
            calc: DFF::default(),
            strobe: DFF::default(),
            mac_a0: MAC::default(),
            mac_b1: MAC::default(),
            a_0: Constant::new(alpha.into()),
            b_1: Constant::new((0x8000 - alpha).into()),
        }
    }
}
