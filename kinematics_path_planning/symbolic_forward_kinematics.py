# You can install sympy with sudo pip install sympy
import numpy as np
import sympy as sp
from numpy import pi
from numpy.linalg import inv


class UR5SymbolicForwardKinematics():
    def __init__(self):
        self.d1 = sp.Symbol("d_1")
        self.a2 = sp.Symbol("a_2")
        self.a3 = sp.Symbol("a_3")
        self.d4 = sp.Symbol("d_4")
        self.d5 = sp.Symbol("d_5")
        self.d6 = sp.Symbol("d_6")

        self.th1 = sp.Symbol("th_1")
        self.th2 = sp.Symbol("th_2")
        self.th3 = sp.Symbol("th_3")
        self.th4 = sp.Symbol("th_4")
        self.th5 = sp.Symbol("th_5")
        self.th6 = sp.Symbol("th_6")

        # Transform matrices from reference frame to reference frame
        self.B01 = make_DH(self.th1, self.d1, 0,       0)
        self.B12 = make_DH(self.th2, 0,       0,       pi / 2.0)
        self.B23 = make_DH(self.th3, 0,       self.a2, 0)
        self.B34 = make_DH(self.th4, self.d4, self.a3, 0)
        self.B45 = make_DH(self.th5, self.d5, 0,       pi / 2.0)
        self.B56 = make_DH(self.th6, self.d6, 0,       -pi / 2.0)

        self.B02 = self.B12 * self.B01
        self.B03 = self.B23 * self.B12 * self.B01
        self.B04 = self.B34 * self.B23 * self.B12 * self.B01
        self.B05 = self.B45 * self.B34 * self.B23 * self.B12 * self.B01
        self.B06 = self.B56 * self.B45 * self.B34 * self.B23 * self.B12 * self.B01

    def return_vector_to_reference_frame(self, transfer_matrix, thetas):
        B = transfer_matrix
        # Taken from ur5.urdf.xacro
        B_w_lengths = B.subs([(self.d1, 0.089159),
                              (self.a2, 0.42500),
                              (self.a3, 0.39225),
                              (self.d4, 0.10915),
                              (self.d5, 0.09465),
                              (self.d6, 0.0823)])
        B_w_zero_angles = B_w_lengths.subs([(self.th1, thetas[0]),
                                            (self.th2, thetas[1]),
                                            (self.th3, thetas[2]),
                                            (self.th4, thetas[3]),
                                            (self.th5, thetas[4]),
                                            (self.th6, thetas[5])])
        B_w_zero_angles = np.matrix(B_w_zero_angles.tolist())
        initial_vector = np.matrix('0; 0; 0; 1')
        return(np.dot(inv(B_w_zero_angles), initial_vector))


# See Theory of Applied Robotics pg. 242
# Uses the Denavit-Hartenberg method of reference frames
def make_DH(theta, d, a, alpha):
    # First, rotate by alpha around the x-axis
    R_x = sp.Matrix([[1, 0, 0, 0],
                     [0, sp.cos(alpha), sp.sin(alpha), 0],
                     [0, -sp.sin(alpha), sp.cos(alpha), 0],
                     [0, 0, 0, 1]])
    # Then travel by a along the x-axis
    D_x = sp.Matrix([[1, 0, 0, -a],
                     [0, 1, 0, 0],
                     [0, 0, 1, 0],
                     [0, 0, 0, 1]])
    # Then rotate by theta around the new z-axis
    R_z = sp.Matrix([[sp.cos(theta), sp.sin(theta), 0, 0],
                     [-sp.sin(theta), sp.cos(theta), 0, 0],
                     [0, 0, 1, 0],
                     [0, 0, 0, 1]])
    # Then travel by d along the z-axis
    D_z = sp.Matrix([[1, 0, 0, 0],
                     [0, 1, 0, 0],
                     [0, 0, 1, -d],
                     [0, 0, 0, 1]])
    return D_z * R_z * D_x * R_x
