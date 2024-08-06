import argparse
import os 


parser = argparse.ArgumentParser(description='Include solver')

parser.add_argument("-i", action='store', required=True , help="input file")
parser.add_argument("-o", action='store', required=True , help="output file")

args = parser.parse_args()

in_file = args.i
out_file = args.o

print("Input  : ",in_file)
print("Output : ",out_file)



def process(in_file):
    buf = ""
    ifile = open(in_file ,'r')
    for l in ifile.readlines():
        if l.startswith("#include"):

            path_inc = l.split()[1]
            
            resolved_path = os.path.join(os.path.dirname(in_file), path_inc)
            print("include file : ", resolved_path )

            buf += process(resolved_path) + "\n"
        else:
            buf += l
    return buf


ofile = open(out_file ,'w')
ofile.write(process(in_file))