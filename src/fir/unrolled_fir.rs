use array_init::array_init;
use rust_hdl::prelude::*;

use crate::mac::MAC;

#[derive(LogicBlock)]
pub struct UnrolledFir<const M: usize> {
    pub clock: Signal<In, Clock>,
    pub data_in: Signal<In, Signed<16>>,
    pub data_out: Signal<Out, Signed<16>>,
    kernel: [Constant<Signed<16>>; M],
    state: [DFF<Signed<16>>; M],
    macs: [MAC; M],
}

impl<const M: usize> Logic for UnrolledFir<M> {
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
        self.state[0].d.next = self.data_in.val();

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

        self.data_out.next = self.macs[24].prod.val().get_bits::<16>(16);
    }
}

impl<const M: usize> UnrolledFir<M> {
    pub fn new(coefficients: [i16; M]) -> Self {
        assert_eq!(M, 25);
        let kernel = coefficients
            .into_iter()
            .map(|c| {
                let c: i64 = c as i64;
                let c: Signed<16> = c.into();
                Constant::new(c)
            })
            .collect::<Vec<_>>()
            .try_into()
            .unwrap();

        Self {
            clock: Signal::default(),
            data_in: Signal::default(),
            data_out: Signal::default(),
            kernel,
            state: array_init(|_| Default::default()),
            macs: array_init(|_| Default::default()),
        }
    }
}
