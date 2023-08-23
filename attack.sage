import os
import string

dictsles = string.ascii_letters + string.digits
Pbox = [0,2,4,6,1,3,5,7]
P.<k0,k1,k2,k3,k4,k5,k6,k7,k19,k20,k21,k22,k23,k24,k25,k26,k38,k39,k40,k41,k42,k43,k44,k45> = PolynomialRing(GF(2))

mode = 0
PLaintext = [1,0,0,0,1,0,1,0]
loop = 256
if(mode==0): loop = 1
for num_byte_index in range(loop):
    num_byte = "output/"+str(num_byte_index)
    if(chr(num_byte_index) in dictsles): num_byte += "[" + chr(num_byte_index) + "]"
    if(not os.path.exists(num_byte)): os.mkdir(num_byte)
    num_byte += "/"
    if(mode==1): PLaintext = [int(i) for i in bin(num_byte_index)[2:].zfill(8)]

    def phiSbox1(x1,x2,x3,x4):
        return 1 + x1 + x3 + x4 + x2*x3 + x1*x2*x4 + x1*x3*x4 + x2*x3*x4

    def phiSbox2(x1,x2,x3,x4):
        return 1 + x1 + x2 + x1*x3 + x1*x4 + x3*x4 + x1*x2*x4 + x1*x3*x4

    def phiSbox3(x1,x2,x3,x4):
        return x1 + x3 + x1*x2 + x1*x3 + x1*x2*x4 + x1*x3*x4 + x2*x3*x4

    def phiSbox4(x1,x2,x3,x4):
        return x1 + x2 + x4 + x2*x3

    def pLayer(arr):
        ret = [_ for _ in arr]
        for i in range(len(Pbox)):
            ret[Pbox[i]] = arr[i]
        return ret

    def writeOutput(file, arr):
        with open(num_byte+file, "w") as f:
            for i in arr:
                f.write(str(i)+"\n")
        #print("done save make file as", file)


    K = [k7,k6,k5,k4,k3,k2,k1,k0]

    Rk = [K[i]+PLaintext[i] for i in range(8)]

    writeOutput("Rk.txt", Rk)
    #print("Rk[0]:",Rk[0])

    g1 = [
        phiSbox1(Rk[0], Rk[1], Rk[2], Rk[3]),
        phiSbox2(Rk[0], Rk[1], Rk[2], Rk[3]),
        phiSbox3(Rk[0], Rk[1], Rk[2], Rk[3]),
        phiSbox4(Rk[0], Rk[1], Rk[2], Rk[3]),
        phiSbox1(Rk[4], Rk[5], Rk[6], Rk[7]),
        phiSbox2(Rk[4], Rk[5], Rk[6], Rk[7]),
        phiSbox3(Rk[4], Rk[5], Rk[6], Rk[7]),
        phiSbox4(Rk[4], Rk[5], Rk[6], Rk[7]),
    ]

    writeOutput("g1.txt", g1)
    #print("g1[0]:",g1[0])

    h1 = pLayer(g1)

    #print("h1[6]:",h1[6])
    writeOutput("h1.txt", h1)

    f2 = [
        h1[0]+k26,
        h1[1]+k25,
        h1[2]+k24,
        h1[3]+k23,
        h1[4]+k22,
        h1[5]+k21,
        h1[6]+k20,
        h1[7]+k19,
    ]

    #print("f2[5]:",f2[5])
    writeOutput("f2.txt", f2)

    g2 = [
        phiSbox1(f2[0], f2[1], f2[2], f2[3]),
        phiSbox2(f2[0], f2[1], f2[2], f2[3]),
        phiSbox3(f2[0], f2[1], f2[2], f2[3]),
        phiSbox4(f2[0], f2[1], f2[2], f2[3]),
        phiSbox1(f2[4], f2[5], f2[6], f2[7]),
        phiSbox2(f2[4], f2[5], f2[6], f2[7]),
        phiSbox3(f2[4], f2[5], f2[6], f2[7]),
        phiSbox4(f2[4], f2[5], f2[6], f2[7]),
    ]

    writeOutput("g2.txt", g2)

    h2 = pLayer(g2)

    #print("h2[6]:",h2[6])
    writeOutput("h2.txt", h2)

    f3 = [
        h2[0]+k45,
        h2[1]+k44,
        h2[2]+k43,
        h2[3]+k42,
        h2[4]+k41,
        h2[5]+k40,
        h2[6]+k39,
        h2[7]+k38,
    ]

    writeOutput("f3.txt", f3)

    TotalLeng = [len(str(i).split("+")) for i in f3]
    print(TotalLeng)

    C = [1, 1, 0, 0, 1, 1, 0, 1]
    Ind = [f3[i]-C[0] for i in range(8)]

    print("Done on printing on file", num_byte)

    #print("Done for make an equation")
    #inp = input("wanna groebner basisi?[y/n]")
    inp = "n"
    if(inp == "y"):
        I = ideal(Ind)
        gb = I.groebner_basis()
        print("DOnee!!")
        with open("grobner.txt","w") as f:
            for i in gb:
                f.write(str(i)+"\n")
    else:
        continue
        #print("done")