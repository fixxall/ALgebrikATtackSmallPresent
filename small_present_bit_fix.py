Sbox = [0xc, 0x5, 0x6, 0xb, 0x9, 0x0, 0xa, 0xd, 0x3, 0xe, 0xf, 0x8, 0x4, 0x7, 0x1, 0x2]
Sbox_inv = [Sbox.index(x) for x in range(16)]
PBox = [0,2,4,6,1,3,5,7]
PBox_inv = [PBox.index(x) for x in range(len(PBox))]

class present:
    def generateRoundkeys80(self, key, rounds):
        """Generate the roundkeys for a 80-bit key

        Input:
                key:    the key as a 80-bit integer
                rounds: the number of rounds as an integer
        Output: list of 64-bit roundkeys as integers"""
        roundkeys = []
        for i in range(1, rounds + 1):  # (K1 ... K32)
            # rawkey: used in comments to show what happens at bitlevel
            # rawKey[0:64]
            btkey = bin(key)[2:]
            roundkeys.append(btkey[-8:])
            # 1. Shift
            # rawKey[19:len(rawKey)]+rawKey[0:19]
            key = ((key & (2 ** 19 - 1)) << 61) + (key >> 19)
            # 2. SBox
            # rawKey[76:80] = S(rawKey[76:80])
            key = (Sbox[key >> 76] << 76) + (key & (2 ** 76 - 1))
            #3. Salt
            #rawKey[15:20] ^ i
            key ^= i << 15
        return roundkeys
    
    def pLayer(self, arr):
        # arr = [1,1,1,...]
        # print(arr)
        ret = [_ for _ in arr]
        for i in range(len(PBox)):
            ret[PBox[i]] = arr[i]
        return ret
    
    def Sboxing(self, arr):
        # arr = [1,1,1,...]
        a1 = int(self.listToString(arr[:4]),2)
        a2 = int(self.listToString(arr[4:]),2)
        sb1 = bin(Sbox[a1])[2:].zfill(4)
        # print(sb1)
        sb2 = bin(Sbox[a2])[2:].zfill(4)
        return self.stringtolist(sb1+sb2)

    def listToString(self, arr):
        ret = ""
        for i in arr:
            ret += str(i)
        return ret

    def stringtolist(self, arr):
        ret = []
        for i in arr:
            ret.append(int(i))
        return ret

    def xor(self, arr, int1):
        # print(self.listToString(arr))
        a1 = int(self.listToString(arr),2)
        a2 = int(int1, 2)
        axr = a1^a2
        return self.stringtolist(bin(axr)[2:].zfill(8))

    def __init__(self, message):
        seed = "1"*79+"0"
        # print(seed)
        rk = self.generateRoundkeys80(int(seed,2),3)
        # print(rk)
        state = message
        for i in range(2):
            # print(state)
            state = self.xor(state, rk[i])
            # print(state)
            state = self.Sboxing(state)
            state = self.pLayer(state)
        state = self.xor(state, rk[-1])
        print(state)

clas = present([1,0,0,0,1,0,1,0])