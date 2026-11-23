# Gerador do AnimStanceLE.esp (so para referencia; o .esp ja esta pronto em Data/)
import struct,json,zipfile,os,sys
OUT=sys.argv[1]; A=sys.argv[2]
PLUG="AnimStanceLE.esp"
def z(s): return s.encode('cp1252')+b'\0'
def sub(t,d): return t+struct.pack('<H',len(d))+d
def rec(t,fid,subs,flags=0):
    d=b''.join(subs)
    return t+struct.pack('<IIIIHH',len(d),flags,fid,0,43,0)+d
def grp(label,recs):
    body=b''.join(recs)
    return b'GRUP'+struct.pack('<I',len(body)+24)+label+struct.pack('<IHHI',0,0,0,0)+body
M=1  # um master (Skyrim.esm) -> indice 01 nos formIDs locais
def fid(local): return (M<<24)|local
# --- MGEF (efeito marcador, so existe para as condicoes do OAR/DAR)
def mgef(local,edid,name):
    F=[('I',0x8000),('f',0.0),('I',0),('i',-1),('i',-1),('I',0),   # flags,custo,assoc,skill,resist,unk
       ('I',0),('f',0.0),('I',0),('I',0),('I',0),('I',0),            # luz,taper,hitshader,enchshader,minskill,area
       ('f',0.0),('f',0.0),('f',0.0),('f',0.0),                      # carga,curva,duracao,peso2AV
       ('I',1),('i',-1),('I',0),('I',0),                              # arquetipo=Script,AV,projetil,explosao
       ('I',0),('I',0),('i',-1),                                      # cast=constante,entrega=self,2AV
       ('I',0),('I',0),('I',0),('f',0.0),                             # arte cast,hit,impacto,uso
       ('I',0),('f',1.0),('I',0),('I',0),('I',0),                     # dual cast,escala,arte enc,vis,vis enc
       ('I',0),('I',0),('I',0),('I',0),('f',0.0),('f',0.0)]           # equip,imagespace,perk,som,ai
    data=struct.pack('<'+''.join(t for t,_ in F),*[v for _,v in F])
    assert len(data)==152,len(data)
    return rec(b'MGEF',fid(local),[sub(b'EDID',z(edid)),sub(b'FULL',z(name)),sub(b'DATA',data)])
def spel(local,edid,name,mg):
    spit=struct.pack('<IIIfIIffI',0,1,4,0.0,0,0,0.0,0.0,0)
    assert len(spit)==36
    return rec(b'SPEL',fid(local),[sub(b'EDID',z(edid)),sub(b'FULL',z(name)),sub(b'SPIT',spit),
        sub(b'EFID',struct.pack('<I',fid(mg))),sub(b'EFIT',struct.pack('<fII',0.0,0,0))])
styles=[(1,'Unarmed Style 1'),(2,'Unarmed Style 2'),(3,'Unarmed Style 3')]
mg=[];sp=[]
for i,n in styles:
    mg.append(mgef(0x800+i-1,f'ASL_Unarmed_Sel{i}_FX',f'AnimStance {n}'))
    sp.append(spel(0x810+i-1,f'ASL_Unarmed_Sel{i}_Ability',f'AnimStance {n}',0x800+i-1))
def wstr(t): b=t.encode('ascii'); return struct.pack('<H',len(b))+b
def prop_obj(name,local): return wstr(name)+struct.pack('<BB',1,1)+struct.pack('<HhI',0,-1,fid(local))
props=[('ASL_Unarmed_Sel1_Ability',0x810),('ASL_Unarmed_Sel2_Ability',0x811),('ASL_Unarmed_Sel3_Ability',0x812)]
script=wstr('ASL_MCM')+struct.pack('<BH',0,len(props))+b''.join(prop_obj(n,l) for n,l in props)
vmad=struct.pack('<hhH',5,2,1)+script+struct.pack('<bHHH',2,0,0,0)   # versao,formato,n scripts | fragmentos: 2,0 frags,"" | 0 aliases
dnam=struct.pack('<HBBII',0x0101,0,0xFF,0,0)
qust=rec(b'QUST',fid(0x820),[sub(b'EDID',z('ASL_Config')),sub(b'VMAD',vmad),sub(b'DNAM',dnam),sub(b'NEXT',b''),sub(b'ANAM',struct.pack('<I',0))])
groups=[grp(b'MGEF',mg),grp(b'QUST',[qust]),grp(b'SPEL',sp)]
nrec=len(mg)+len(sp)+1+3
hedr=struct.pack('<fII',1.7,nrec,0x840)
tes4_subs=[sub(b'HEDR',hedr),sub(b'CNAM',z('AnimStanceLE')),sub(b'SNAM',z('AnimStance LE - selector de animacoes')),sub(b'MAST',z('Skyrim.esm')),sub(b'DATA',b'\0'*8)]
tes4=rec(b'TES4',0,tes4_subs)
os.makedirs(OUT,exist_ok=True)
open(os.path.join(OUT,PLUG),'wb').write(tes4+b''.join(groups))
