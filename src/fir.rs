use array_init::array_init;
use rust_hdl::prelude::*;

use crate::mac::MAC;

#[derive(LogicBlock)]
pub struct FIR<const M: usize> {
    pub clock: Signal<In, Clock>,
    pub signal_in: Signal<In, Bits<16>>,
    pub signal_out: Signal<Out, Bits<16>>,
    kernel: [Constant<Bits<16>>; M],
    state: [DFF<Bits<16>>; M],
    macs: [MAC; M],
}

impl<const M: usize> Logic for FIR<M> {
    #[hdl_gen]
    fn update(&mut self) {
        // Clock
        for i in 0..M {
            self.state[i].clock.next = self.clock.val();
            self.macs[i].clock.next = self.clock.val();
        }

        // Shift states
        for i in 1..M {
            self.state[i].d.next = self.state[i - 1].q.val();
        }
        self.state[0].d.next = self.signal_in.val();

        // Route multiplies
        for i in 0..M {
            self.macs[i].a.next = self.state[i].q.val();
            self.macs[i].b.next = self.kernel[i].val();
        }

        // Route accumulates
        for i in 1..M {
            self.macs[i].c.next = self.macs[i - 1].prod.val();
        }
        self.macs[0].c.next = 0.into();

        self.signal_out.next = self.macs[3].prod.val().get_bits::<16>(16);
    }
}

impl<const M: usize> FIR<M> {
    pub fn new(coefficients: [i16; M]) -> Self {
        assert_eq!(M, 4);
        let kernel = coefficients
            .into_iter()
            .map(|c| {
                let c: u16 = c as u16;
                let c: u64 = c as u64;
                let c: Bits<16> = c.into();
                Constant::new(c)
            })
            .collect::<Vec<_>>()
            .try_into()
            .unwrap();

        Self {
            clock: Signal::default(),
            signal_in: Signal::default(),
            signal_out: Signal::default(),
            kernel,
            state: array_init(|_| Default::default()),
            macs: array_init(|_| Default::default()),
        }
    }
}
