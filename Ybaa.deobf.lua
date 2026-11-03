--[[
  ДЕОБФУСКАЦИЯ (частичная, максимально достижимая статически+динамически)
  Обфускатор: MoonSec-подобный VM-обфускатор (luaobfuscator.com, пресет "VM")
  Выполненные преобразования:
    * числовые литералы 0x/0b нормализованы
    * свёрнута числовая обфускация (a+-b, a%%b, -(a-b) ...) -> значения
    * вызовы доступа к строковым константам заменены самими константами
      (в комментариях [n] — индекс в исходной таблице строк)
    * код переформатирован (структурная beautify)
  Примечание: VM-обфускация (кастомный байткод + шифрование констант 2-го
  уровня) не разворачивается в исходный код автоматически; строки, помеченные
  как бинарные (\xNN), — это константы 2-го уровня, расшифровывающиеся
  во время выполнения VM.
]]

-- were back online
return ( function ( ... )
    local w = { "7*g]\\;;A\\7oc&l4" ;
    "7TChF)#X" ;
    "7oMO87SKUW3" , "7#9>\\Lq\\1aO;C" , "7sch7A!\\f[%e*mC;9))^UL%Ln3*TW" ;
    "7InORh8\\*YG8b;LOM/j" ;
    "7oMG@1*gD" ;
    "7AFuePh>f" , "7T1VpAp!<u2@f45VT+1" ;
    "77N-M" ;
    "7,Mf<PP%<qra:@5XRd" ;
    "7P;?88M%i`#)!EJ$,T" ;
    "73g\"mVlp]," , "7=K7$Ud:Bg" ;
    "7m3,LUY_,1#8?&-IPO2" ;
    "7Kgi;Xj9B#X+0P$" , "7\'0Ual" ;
    "7JB[,fbinj=" , "7YNuN" ;
    "7*IB7fInB\"oM%TBXm(B" , "72F/IYO^^FNWCN/" , "7i0dRcM9G" ;
    "7+uuc:" ;
    "7;,,&;" ;
    "7f`D@s8d^o5\"_R" , "7DV53i`#0`f.Ts" ;
    "7%jf;.?NiUC.KHiTR:UBKou[(" ;
    "7\\osDq" ;
    "7IS?j9>;0b(" ;
    "7AY^Ddi3#" ;
    "7IMlY2" ;
    "76hC7VuZA_!`CT" ;
    "7^Tet" , "7+7/.G*81hn/!6>P" , "7+O?]PY_L@lPO2" , "7PrmStd\'e" , "7n>=(YTMtWO.0S" , "74L%o2Ll+6@" , "76mC.6.Qs=C0SE3/o]o" , "7`FZt$F_K" ;
    "7l#dof?[#/J,ES" ;
    "7p<h]" , "7\'g]D=ae(T7:VuK])`" ;
    "7J0Vk[!T" , "7*Sf=E:\\aF\"IX:gZ*J" , "7b,4X-" ;
    "7\'bXSV" , "7IICbIacW)M*&e-4" ;
    "7\\Y!X+I(Z[5+eE=\"Rd" , "7ei)6uCr" ;
    "7ZL\"n]kHoa!f>#1\"*Dm0_" ;
    "7!KKtlZW^Mg*KgHpq-\\L^M8)d)@<IgKq]6" , "7?piOq#=02FhM93YC\"s" ;
    "7n9nk\'6(hJL7FnbL>0+" , "7Zcj`Di#3Hj\\[ZjGN-poQ+i" ;
    "7dC3il+Sl$\'^-" ;
    "7bE>.6U)2:p" , "74Ai?;3dO" ;
    "7b-mC" ;
    "7[fT%cb)s" , "7m?)$>`F)=@&%" , "7\'(iC+&)hb@k!n" ;
    "7W9[ET4,Z*5PAS_" ;
    "7S.HfQMR=7.f%" , "7?FB9`34>JHm(;Pcbp&UTU2" ;
    "710g\"C9LBO8s/t" ;
    "7:[_$])m`Oj,V7f>\'YS" , "74.\\9*!EhgnIo_g@" ;
    "7Ya5uX4#>(ZLU\"3<" ;
    "7Y_rXe,u[`N+;8_i:W" ;
    "7-)oiJg\"$nd82T[]$r\\`m" , "7,VV" ;
    "7fQoK" ;
    "7ZuUR9:0KrRafcf/" , "7b%<=GAN=S;8o&K" , "7-OIaE]3dp\"h2,Ip" ;
    "73$?*k4E_4F,T[BfM;nUm4KZa2jg\'" ;
    "7X)c9Z" , "7/\"H5" ;
    "7I:\\P^oKBi" , "7U<rN.CQP.]dQ$t_" , "7HuM(.lT,Zq\"XLUl-mjapPS" , "7;,,&;Io" , "74,Z)N" ;
    "72qrB3r\"@Y" , "7m5-QH" ;
    "7acS;Ylb2JA^ULZ6" ;
    "7GQY7g" ;
    "74:<mAW0f" ;
    "7eseT\\2B$C[]h" ;
    "7P*l#I\'<PGR)_0N^Rt" ;
    "7I[lW?" ;
    "7U8@@ZRnJ^X_)@=\'sR+" , "7[Q+!q" , "7^oX@5!TUZ)" ;
    "7)&$[\"5G/nWcATlYY(0_M!o" ;
    "7\\P2`M" , "7/YBl^_)+B" , "7W9[A#LW" , "7fT:PLF0Z?BnQU-b6eEGi" , "7e<1CE1Y" ;
    "7Dh2?\'e/R3Wc\'K\"`(N\"`!" ;
    "78cCG2f/" ;
    "7/5b(e" ;
    "7HJ" , "7`$:%%A(\'/Hk+8" ;
    "7(=SCJrXWo_Pq?W#2gRo?" ;
    "7%Ml?4b>_8#IT" , "77!f<\'[V\"\'" , "7mth8YBt@=e" , "7k5rPLa\"D%>g,^Q" , "7V]C%l561?" ;
    "7lq,Dt:f60dFF)06/747n#h91FgpR" , "7E;IT:6F" , "71%d_;f0cACJr" ;
    "7l*Z2XG>r\\T" ;
    "7hjWigUSeEk)%;,JLL30=U&n;0:Q3HATJaFq;FF^8^]LDla5M" , "7*@\"2S" ;
    "7iVU>k!S]" , "7Ruo]\')Wf\\;Y&jL?L$" ;
    "74gZ:h\\oL<e42/-`aX" , "7e)MGU+5`)$D_=" ;
    "7\"DWLa3&;eIR*m,+SM,l)" , "7L<mmPVs," , "7bM#ta&%" , "7+9Q_I)U+MS^8SFdYf\"@C^4u.SnBP4r^&X`O_p9I\'gl4\'&#da/D/H=mjO:>" , "7Gm&e" , "7\\$>rPJ=am^\'R/OsBWng<" , "7hGN4kLdjPr?I*Ct" ;
    "7Zp%\'M2Dt@7:\"J!!" , "7!HobEBgL%A" , "7$Ho/l>C[G+jpgP" ;
    "7U_*@QHYGlGsUJ07#((#" , "7<H`BDeJ2!0g)NH:eOAI[;C" , "7++_3" , "7bBT2P+7\"4g" , "7]qu)\")-X#ICk:VhI4&[q" , "7TgBlHVC+/h" ;
    "7&?fTrfHDJjjXS*q24WCM!0^n)Ng=Va^;,,S" , "7HMQe" , "7Rm`6<a&1V=-ja@fjH,]" , "7Ud$l" , "7??(X(#A7" , "74,YC7Y?" , "7mI#$%m3,LUY_P" , "7)Q71&LSM?bPrO" ;
    "7=[8;[Bo" , "7?%T;3XhCFW)m23/B_B" ;
    "7/ldg" , "7@lKQ8\'6<)" , "7?05UHTWTOu" , "7-0Kj(0A!s1J\'2$" ;
    "72iC\'/" , "79N):3\'nE*u`P7(%FRpI^" ;
    "769Fa" , "7nFnM2" ;
    "7\'2>\\F:Boeim3SrCPfu" ;
    "7P\'+L$\\<8MT3[jc1kF^jenYO1cW:" , "7rkC;$`P+#eY!p)X>O]V" ;
    "74J.0XPOt" , "7Vq*N0" , "7qTX`XED.+(" , "7:hckX86geq+;.,:" ;
    "7)9=>ZYsU" , "7:E-S3" ;
    "74Ya9N5-Bp@&9D-W1\'^0a6e\'>?$`VY]m10;qmPs>^S`CA*%X8DNKalqUN4j:!lB3c$Hj-\\eeqcRl.cR:=^\\^#e&hH!]BT" , "7&u(Q31i1" , "7Uqh+KBBcAG*I?_om@/dn**C:ML7h" ;
    "7m,t<LA@#[Yile6k$,7k&#_iI_\"Rc" , "7$Tn.^" ;
    "7O3AAQcb0" , "7_^R@lu\"" , "7.B%VB1OL,k3;" ;
    "7U5]CA" , "7T)cUfGoE9o3iX`" , "7k-(/*$en#GlLAn" ;
    "7*UJZ" , "7Rqqlr(`3t" , "7T\"!TdLW" , "7s:okLYmHVL&,8" ;
    "7nfoA&B31TcpMF&2" ;
    "7W9[(VY+Tt" ;
    "7Vae#UUa7PL;r" , "7gpJ.+\'PYag,QL%NA(h=" , "7L:LiH&B@\'FJqN" , "7:JD7;YeQ[m,]Zkg3;" , "7aHEj" ;
    "7)$)]$8#]" , "7q%U*52F?kK?VBD" , "7;Mu4`%Tn" ;
    "7e5\"\"oAd" , "7q8OR_X`fL`" ;
    "7NN2Ob[->qO-)kGi?QdZK-9aW" , "7\\ZH3fmmrmF*8" , "7At" , "7Fn%S=$`" ;
    "7l#fUKqh" ;
    "7X^9p@nEFiOXZUZ" ;
    "7i\"k9Lbhp_" , "7_Dq&" ;
    "7]a1lQ" , "7[QED" ;
    "7&W%F<$lpI" ;
    "7S0@2AruFF" ;
    "7\\(?j" , "7;&_p0.9j" , "7D7(an%!Cg-nfr7" ;
    "7VcH5`#oqfVKL[>" , "7S@,><$E\"7Z\\llB;=pB" ;
    "7KL0^24Es9" , "7$;J#!e\"" ;
    "7KpG(fU6KR7u.k_QI3t)SOns\'[sC=" , "7],rmE8jWX\'d/" ;
    "7!66%G" , "7+fP\\6IXC`dP;)NF" , "7gJ!9SUJQH\"W[Mc\'N6H\'pIT" , "7aF(?:" ;
    "7]@U3b" , "7&W!D" , "7*i5A(3o;q?mXW6!\'H" , "7Psi3>\\1It!8.*QW3\\a" ;
    "7CKR_>[XOc5NJ@]c" ;
    "7IgJ_" ;
    "7;Vf\"ULSj_" ;
    "7m:JCga&UT\\4buC(mZ" ;
    "7)E_\\L84r\"@?;&(`IT" , "7B>!JeXmg/Y" ;
    "7/\"15e6^c7" ;
    "78^mJRlU6\"N" ;
    "7gtKV9" ;
    "7AguobgL[kt" , "7^8LVji2[hU\"a3FiY/kr(" , "7=:<p3T.6]3;0sVd" ;
    "7$fI!,jIa\\\"JFC" ;
    "74qd8@\'DLEWbQcs9IDC@#Vr7d$E+m" , "7LlTs^_Tt" ;
    "7Wb[Jd6c*N`9sh7esTYeA" , "7phIa" ;
    "7J\\T1=JluZLYlnrdKbBY" ;
    "7H@XrlH3:O+<`atl[X\'" ;
    "7mI#$%a_oCTZc$." , "7G-1r47*m(+eJ1n" ;
    "7o!@2_ntTkR" ;
    "7sUZ0&d%" ;
    "7V&-N;ZANKPa2j=" ;
    "7=&>!:Ld" , "7plkFQ-\"Rp" , "7@coAcR=1od_,g]KeTKg5" , "7fpF)r1#P" , "7Pr?)7P;R" , "74F.\\mLho" ;
    "7Jpu/PWn4" , "7^b^7+Ko_PRO(A&::)fri7h4BPfA`" ;
    "7$#f1%r0r/;" ;
    "7giZ;#:d" , "7POTm>" ;
    "7>->A0" ;
    "7\'J)=%)TE!n*KQ3s?8W%P" ;
    "7!@N;UX1)t)clW" , "7[OLk" ;
    "7_ta#Z" , "7k:bRh?-" ;
    "78].EL)skKSMB#H$:d" , "7WEij9Go" , "7^^tLY012pG" , "7hbB0u%Zi0M?]bU.bFpL-" , "7C`nPs" ;
    "7j:<j\\-NfIk\\)j8n)U$tt-R" ;
    "7/o-&\\" ;
    "7Yk)^Aq\"<@\'sZ," ;
    "7\'Ub6*8V[MQYa??!4Yr" , "7*jK:qj_Dr8:QS%kOCP" , "79\"b]R:J%LYW$\"" , "7e8dE<>L*M" ;
    "7<BlMT" , "7$^qb" , "7J&YWG?X*" , "7Zu-b(:i`EZYcMkWZ0=S" , "7%Z7^" ;
    "7H=tSA" ;
    "7L5/GIn\\p.S" , "7ZfImt" , "7bl#mm!,pkS5m4:<Bq8si" ;
    "7PKHQgsX" , "7oQ,1^(`!p8#]UqJ(tKYrk+j9mN?D3" ;
    "7YQ#0e>%" ;
    "7#^si4ICB,(OpM?bBdp]Og9hB>o>:2M4[\"0@" ;
    "7;#uH0I:uqV:8\'/N" ;
    "7[Q@;i" , "73bd$(\'dcH;,XM[2a:B" , "7_+oIT!dSXgLd" , "7dcs$l6I\"b" ;
    "7Zc$M@YstE" ;
    "7#bAS7lH\"" , "746IFZ]&afmXV5ZO`\"61k\\BRr;#7=" , "7.Q#L3" , "7&3C%pfsp0NucrJ)" , "7_\'G_<O(JKn7+`(cMN&-Gi8$[KC[V" ;
    "7H,nd];;" ;
    "74FA9" , "7Ta.h&L$" , "7V3Hqk0fRD2Ad" ;
    "72h\"Mo.W;[1uL1" , "74rRBu#\"l3Q" ;
    "7,i6]B" ;
    "78=J-rLSd" , "7#Z6@7\'Ao&Mb]e" ;
    "7*p-HlVa," , "7:=U><PH<2iL^Ll^" ;
    "7O7P2n" ;
    "7el4@[:mERsqkF.+=_" ;
    "7gGrLc-9>&M3D.h" ;
    "7/kV3A=Mk;s`7SkU4>Jg4\'-n6C\'8@" ;
    "7:.Yt\"\\Q`F>YekVX25u" ;
    "7E;<B" , "7)$)kgYjSS" ;
    "7Ou*GD1+CP]" ;
    "78Eomk.!o" , "74(_@" , "7K(.," , "7Z:L/R*IU`jm`1s-2Kb" , "7j^r(48/;kE" , "7h\\#r\\" ;
    "7%om9\\O&K_soW\"" , "7c9Ms,qRVL-)C%e" ;
    "7>3lS." ;
    "73q83]V$Atk" ;
    "7,Umm" , "7A4sJ4" ;
    "7YH.,b8C" ;
    "7\'[nS?#%oYbC0F=0+IY(I:\\c" , "7M&8B%m[ae@\'d2f+8FF" , "75]\"Q<DR=4^;]M:W" ;
    "7FpYb6" ;
    "7%(" ;
    "7&>A*Ad_&BYo<A" , "7\\Yn(R4.E&QY?" , "7-5a5E" ;
    "7Oe-BN/XBq-&f" ;
    "72#>#[Kp#M+M]K" ;
    "7,ngDG;^6Bf,-=s/,Z" ;
    "7Y_jBI\'tkV/+2Bi+o)j$6lHEa#ScgH#^n;q4,?tMQ!BkY[sQV9mUOaQX2MSVF&.)E#rOJm@SiNs<s3Uq,@M08XMKihHZV3J,h&qNI3ihG_p5\\IRJl7,H\'R-<O+X6b>AV@Pe?WI&)Y!,o9E]-CnNGT$0U@be+Rm_7JCf,\\NT8r(-<PlhnFO68_)90==7Je)RJnFJe`<KR<%*5aBfUb-JpARUg?0WA5lM#\"Bd.O3r\"fAq+;)M]\"*/H53=#Bb&n:a^O+c]f)USdmR=[;,@3PhoZb(#M.#KPufEa?8CI6`jj?MUH0,lcVJr9)#0f`[U:hH`mbPPrD&UGmB)-hj1Sj>G6CW54tlhL5+Tq10E>nck`DjZ2l!Wi3#e4XDVnmj\"qr(S`EO:l5Y`pK\'>3:pQbMZj\";S" , "7H)+Cu/fT" ;
    "7UAM@s" , "7+C3M]" , "786u>B++B_Y3^S1BI\"X" ;
    "7%esf" , "78<M9#K<3f$c>Z" ;
    "7\"Unaeb2-\"Y" ;
    "7>>Dtr\'F+[:i&[b" , "7m_eRE%?-=2W:" ;
    "7nX=!F&Pk" , "7>G?e%se?thg(+W" ;
    "7*>gS9" ;
    "7\'2BK)9/i" ;
    "7kS`^pD$Th" , "72ktPOk_" ;
    "7()?I" , "7=.ok%;;" , "734nIm%:" , "7?U1RGk5H86" ;
    "7FsjqG\"6@p7o*mc=" ;
    "7Au:6@VU#0!" ;
    "7;C" , "7SOW\"%P@4?hb8S--Z<]%Y" ;
    "7VKp\\2$\\>Go" ;
    "71Hi144RT:*bVJ`*a.;;8s?\"B-O/*" ;
    "7BC=+f]6iRi5\"!<" , "7eGq7,0!9Q>PPS<" ;
    "7eYiM6Et," , "79L7mSS-l@E;r" , "7i@\"`T=-V?a" , "7AnSUP/:" ;
    "7" ;
    "7nOhJ<#7jBJIO[.n9GoCX" ;
    "7mnqAZ`R" ;
    "79YqsC.*V\"X&/" ;
    "7m3,LUY_,1#8?&-IPOYR8?dj#*Li\\" ;
    "7P1\'S^S\"FfGp!Sh;]H$Fh" ;
    "7%--9,uHO" ;
    "7a*Yrq+O?\"" , "7L&`&lL\'>LJ!Xlf" ;
    "7.8(,IJ\"(QYY#h;DfdWCR" ;
    "7D0-E@6UMtisHTp?Ii:;,f/" ;
    "7aP/d-" , "7?d56X" , "7T@#iFCQ\\" ;
    "7\\9\"=S\\Yn2IP_[Lu" , "7>2\">iARoDe" ;
    "7O>Lc?s@ZDT_J" , "7O^bH" ;
    "7R[p?jLSd" , "7T0gm_&&S4+8)L$DZ6EZ" , "7;VD=oH54Og-gL\\" , "7,,NBT+C,d6gi" ;
    "7IPpAEq?@" ;
    "7I;R;e:/I-k0X$!" , "7X\'Qo+" , "7M7/.P.\'UGNSG\"`4" ;
    "7\\-/XG$.<s*T." ;
    "76PT\'E%Al*\"<U2=O=l3(Y" ;
    "7bYqs" ;
    "7Old*[@I.`RR;j" ;
    "780Xu\\" ;
    "7]_\\cR" ;
    "72<:h8I-E;g+Cm+A" ;
    "7(8$hJUp&fq<C;^" , "7G9hl[" , "75T+\"\'[,fMF" ;
    "7dd]R`NJ7CmJ]8.TN43S#iT4*" , "7hElj)oL(j`#@lnJC_>Yi" ;
    "7fu<.2Vf" ;
    "7@+\"HF[&4u" ;
    "7-WuED\'I$3" ;
    "7,?QV" , "7Sl9h#&c+=?" , "7Kli%i6=k>$" , "7Y%JY(4#$BA:L[75+_Z" ;
    "7D.EL_8C" ;
    "7+R])V" ;
    "7YVi\'/c%`89nt1<O" , "70f!IC.Pu[lsbQscu&)nHf)" , "7m;$?9Rg-" , "7B+V+\'ggP" , "7(b](o?\\a!R" ;
    "7PfNR(#Wb8O7Ik" ;
    "7ZlZe^P>L/h_\'N" ;
    "7B&,@iehoZZ`8FjEB\"Zt&5H" ;
    "7P*@Yg`l(" , "7`][]P" ;
    "74LVo$,n&#o4b\\" , "7a&Oi8?56ZbMBHh," , "74bi?IY_APoPm4<=" ;
    "7lNTSgX^tR4US<2C3C" , "7+aje7$ZIs1" ;
    "7n+1+s" , "7\"\"<GE" , "7mo" , "7H@.EuYj)e" ;
    "7$b\"c/qniLN\'kn-sKZ6k\"" ;
    "7(=\'cG" , "7N[F(53u<" ;
    "7.Rqa!Tf<" , "7GkHD]*X*plX%//;" , "7snSJl9>AeMK6r^tu(S*>f\\\\7N-5X" , "7Lf_+4" , "7[X1u$" ;
    "7+Ba[X$F)O" ;
    "7c!`rNd$g2!cP8_a5Y.\'<At" , "72ZCl-Lh+ASO!X" ;
    "7lD4MT" ;
    "7dI=9UJr" , "7dZs;*,^Cg$ZCcR" ;
    "7)Fu8OW!i&Cp@?>-" ;
    "7*cOI,m0EbEZk><d" ;
    "7Di9j\"jWu\';" ;
    "7pN5:p)BC#[*F)q" ;
    "7H):o&o8W)S" ;
    "75/9l" , "7JT13qF;" , "75/m1t" , "7m-6/\"" ;
    "7;g4kF`hM?u9f8" , "7>\'$F" ;
    "7d!t*H2Uc]A5ot." , "7_TnJBntK;FCR" ;
    "7;^(eVL4eU9L$" , "7263(FLVVP:a%_E^" , "7;L\\Ls8NL4PZnrUaL$" ;
    "7;tdoE;6b" ;
    "7/X,&8Kkm;bBS\'" ;
    "7E=slLbqsc2" , "7`MV>t" , "7sd/b<" ;
    "7jRFXW" ;
    "7r&!>25K3_Qi;<sG[=\".jan1" ;
    "7E/[ct3KH[" , "7ZsiA!rU8" ;
    "7:WT;8m4?" ;
    "7Wf?%\"!PjDA+$[aQZV1bB`a?\"*Gik" , "7oCW@\'DB%f_.-S1$Y!(a" , "7P_e*XDu>Kt-F/" , "7,VE" ;
    "7jg2c\\" , "7nPS,c\"\\*" ;
    "72IK)\'" , "7Smoqq&P^=)" ;
    "7504nVA93t*F5VL&H\'<[\"" ;
    "72<H\'*[0" ;
    "7n``3" , "7Zcf9B" ;
    "7;NMCUY_YeTY_Aie4,utN" , "7Y_LBM8C" , "7:9kMA" ;
    "7C6hE/\\/" , "7q$6Y.J[IS\'N/7MLiP2K4BZ4hc#JC" , "73hBr" ;
    "7[sX>p_u]b9<@e" , "7l-&,b" ;
    "74K+;8M8" ;
    "7UoZu=KO7cEZ(_(bsEJ:+u\'.U<</N" , "7Lllp5" , "7a%H9OYeNQPPr\"--" , "78VMFN\\<," ;
    "7dcWOZkQ8mC" , "7e,*2+MY?[<?Q`" ;
    "7RF.,0" ;
    "7$f3i8q%Kppm/f" , "7,-;Jq4F.\\mLho" , "7dTKTUZ)Rla" , "7bSUq_n0/A/#_Eus\"7IO" ;
    "7&;V#f/Tl)R+i" ;
    "7=mSGF+P!**>lpB" , "7`ij*" , "7j?%dIBY" ;
    "7WhE6f;r" , "7qnm!2YpJ2b=9e*Rmo" , "7HOO" , "7eL:^&rA" ;
    "7uHMNm" , "7rlUhR!?NN-dMg" , "7)&XB" ;
    "7E-H1D!aD:*" , "7mufucRSWsV;#g]DaX" , "7[AC(nUCR[Lc-+" ;
    "7?`\'@Lrr" ;
    "7YO5Wn0m:)<\'Rk6" ;
    "7RGN#W" , "7;.\\\\n:u2Hja&4<t" ;
    "7;1UKtLNlYQmG%]U" , "7MSA-\"8?fK6m\\q0n:h`" , "7Y?)rJnJn>MB*U3M]W_b0" , "7)q]a[hQ2VJsO@\\l+bF73" ;
    "7l)K$0*bL" , "7*]E*2" , "7Oe6M+" ;
    "7PCNV`I[fAL;[^s>" , "76`qJ>&#/<!j!b=" ;
    "7.Pe\'" , "7#p@O=p\'M^8b6" , "7-0)_cWb?W`\\k1!TCUdo" ;
    "7-EEf" ;
    "7!&DW\'S5UB9c0r" , "7Xfsa" , "7BD#!&" ;
    "7\'pMH[0?" ;
    "7TfWD`)/C>V^!e" , "7N.D3;T5QFd" , "7#fS%A>qu#uaNP%T$l^O" ;
    "7/(/[n1@@asU=02eL$" , "7oJ^-T" , "7<An-n+.d3Q" , "7g3>dh/^d3DJ:#-\\MW\\DI0^" , "7Z%sF;\\Ym#$R\\*Y>RM-" ;
    "7JMqCp5MF$f" ;
    "7Z)03." ;
    "7RicUPjZR5AYLN@kGd+N" , "71qXQX\"2XOoYOr9OrIg9" , "7:m;.^;n6" , "7euGB8&P9" , "7b(6UXMWV&r" , "7a7;D8RBGt+M>V)Z" , "7K2lAHRZehh" ;
    "7(d\'@" , "7`+%/D,5Kh2+:.j\\#AbNE" ;
    "7\\X*HM" ;
    "7U8?-" ;
    "7W`-b" ;
    "7f8./uZ\\_!N" , "7mMb]qYpB_g*BODM" ;
    "7\'LsH+1]*%K%*OHnI5$" , "7?mIaS" , "7_UgnJli" ;
    "7\'bXSV+C3;+Z&L*e" , "7DGE-b?pB" ;
    "7L_Ch5-tl" , "7n!I8" ;
    "7l4#df0\\(6\'" , "7)QG4T8\")c" ;
    "7,HC!.>^\\l:Ss6" , "73C" , "7m/X7-=^P\"g0j,b" , "7P)q]]:?;<?YekuX\\f" ;
    "7^,8*adAaMmcNeT\\<Nun" , "7DH@]I;O9W" , "7<\'c5u3Yb[p" , "70.S;Ef,VtQZ4Q" , "7;JkM`mG%+&Z>TR<" , "7:?6" , "7]l$:(pQi.q\\D&`CprS2" , "7M`JiEYs&kBR.`&QY\"" ;
    "7*(So8<h0<\"V)h" ;
    "7,Skjk);/\"Aaj9(R" , "7G5.\"md+BiQIo," ;
    "7Y$j@;n]ph<" ;
    "7Y_3H_>L3\'" ;
    "7A@3Fgc_bd/F3]<Z" , "7ha=]5S+25S)IJ-JmU+g" ;
    "7d9FQh^<D;B" ;
    "7Ti.t(dCZE\\c*" ;
    "7kt`lY.8Y/,E&R)SJhN" ;
    "7ns\\Pq(^*" ;
    "78IJrJ%mI9" ;
    "7`BM=si." , "7)$/=?4,V" ;
    "7ebL\'" , "7_\\od)Pm<WF$SeV]9L[[D@^.THsjU" ;
    "7F&,>" ;
    "7b?&?t!$if\"%+GTS" , "7>+$/1H$BHc\\gfLL" , "760:)9" ;
    "7m-,&$*(sUemu>X:\\\':" ;
    "7$\'Da" , "7LX)e=6C?Go&sk" ;
    "717eU>jjC#5g0" , "7kt(,IXD!`A" , "7GL9B%E/" ;
    "788?mc\\\'KIL8V0*;Y?" , "7*ua0O`R" ;
    "7RUU3m,]U-\\+R>.M+i" , "7m(fB]>XC5GM\'I`&" ;
    "7I8CK1<ku*>" ;
    "7$Qh%L8/uAaVO^8GEsp." ;
    "7-r9mJhgV604Pd" , "7J[XT2$.e" , "7DW:%aU,Ie^6ED/" ;
    "7+eP\".*G-sH,n$MOYf8" , "7B1%=" ;
    "7&lf-hFm):" , "7adjq" ;
    "7)r]TD*)C%H*3DSTaX" , "7kpas" , "7=MlFgqqnF" , "71u1VdM;])0%cOA" , "75EKf:" , "7+usd" , "72hX)Zu?>?l2^-uSfu\\u" ;
    "745Os" ;
    "7rVC86OIaa+Jk[mb-(Q\'\'NpZfhm!PuYi8U.qjQ,V6E:\"KFBP,i/b?." ;
    "7Drss" , "7E8I,!lM" ;
    "7;/$<@;r" ;
    "7D\"gZ?IG_$\'OnOTeq%l%-BQq^FYW\"" ;
    "7feBKJNlp0`" , "7^#n8NX.E_FlM" , "7J+9li[/U7\"*22Z8)Urj?A+:reWeR" , "7%-)e1[>j&" ;
    "7T(?4)2]@" ;
    "7Sfqm4b;lg" ;
    "7_gou\"" ;
    "7mOjc`qb-" ;
    "7[h.W*>?c" , "7\'DAZCPRVM" , "7:N!#-m[aOqa/H:.m\\L" ;
    "7)EWt" , "7Ud\'74h!1u7s<h" ;
    "7\"I\"63n$" , "7a_<4pLJIKA)Ch59a/&" , "7`XZa2X:6q" , "78N;;q,T" ;
    "7/A;&" ;
    "7i,Ahb<TV#D" , "7s,S$W_Gkb9[cotRLkYc6uV.*Ab3S_tq2KKqLW" ;
    "7\"/mDYMs,_ZdN>" , "74n==*sW(W<>DGKX1,\\$]" ;
    "7OXdYtD+I" , "7?-8%i+uoh?5EsL!>`dV<3;)SQ3SD" , "70rm]sMVN^79BGO=!(s6XL\'kS^/PH" , "7?mL6eap+h9\\En@&;;" ;
    "7J=P]X" , "7*W(a/3Ke\"9Jq)u#fNqZ3" , "7o`_8isa/B" ;
    "7\'sFF7+B?*q=a+`OYaU" ;
    "7d_\\hRl#K]f]l>3" , "7c/+7Cg0F`\"(5\'j" , "7TUZk&Ot" ;
    "7\"#g:" , "76L51FsEYr-fkq=e" ;
    "7MO]>]" ;
    "7j`ICoB3U\'0MK*+" ;
    "7k)WC]\\-@<98uk" , "7%?7#K*0WoFP=-dLE4_rG" ;
    "7rYutt" , "7:e[^6jU\\sn</@" ;
    "7m:Cg,P/lu5Y`DYD48]" , "74L%fZ8V_8b" , "7i*LU)0&H;X`02M6&2<RqM8" , "7[iAB\'sB_3" ;
    "7?\"qb9" , "7>hM,pdD+a(" ;
    "7B)DRq</nV+>CS$pG8:t" ;
    "78NF[K8r" , "7Zf(bDPOE" , "748Onm" ;
    "7OK&Ej?ubq" , "7=LV2" ;
    "7:Es$>" ;
    "7:!W.meU>!iu!]" ;
    "7!\\IMj" ;
    "7a.]W?" ;
    "7(HO3L:$" ;
    "7XhUQ]@6M#5" , "7+)l7?0\'QJ3" ;
    "78XH$I4a" , "7pMS-+7U(%lAfD^55t%gilM" , "7-KLA:d>kAb#<`\'" ;
    "7RS/n_;L&RE,n#o`" , "7TqXHLK)S?M" ;
    "74I)!`At" ;
    "7$+$%QKeHinfrY*)J9bRdf61/" , "7Gt#Bt" ;
    "7EmR1" , "7JOJ9ec<i" ;
    "748OnmLua" ;
    "7sY\'(Vqa>o^#I>r+R>.f" ;
    "7W9[\\!" , "7Zc$Mt4UG" ;
    "7^nd`VD\"pjD1aO" , "78gbsrPsW" , "7(;,N/" , "7:LHA)I`&?c\\Q7Yo8;" ;
    "7m[g^/ac?;i)gbB=" ;
    "78<Q?uL?Il3;Ug4!\'ZX" , "7kF1s" ;
    "7>i61BjCe" ;
    "7X*+E\\.]UBa3%;`m3*nto" ;
    "7msnRK!7]PX" , "7Y`\'jaYp1?E25`ZQY)h" , "7CFM$I]JAlh" , "7U\'tp5q0" , "7W#YTM9.R0aZ];" , "7(203>Ve6BRcU\\Ien:)\"5:`GF&\"g#O0:&Gn;<PpqG3>+!Yg5<-+!%qHl" ;
    "7Bd\")B" , "72^I@3R&OehC?&r?DC" ;
    "7c6YCQX.d?rSfAmV4?$" , "7L&O9X" , "72eW\'Q8$]B" ;
    "7O=8#MC?G7gp!dg[5_o" ;
    "74JUc_" ;
    "7ARGLh" , "7R[@Wg" ;
    "7P936X" , "74.kD6PjVMG:MO.U" ;
    "7>kj`i6uE\"N$9j@sp<\"gJ.J\\3?<q\"W" , "7\'@,>M=8>9K" ;
    "7HPlc[#aPCb<uL_DfH\'D(Zj+bLCC`" , "7$on;Rk-d>oNrKI<-C]]" ;
    "7/B6gB8cG8@3u8%7" ;
    "7a_o_>PRTj]" ;
    "7EKda[4G:!%;WA&" } local
    function P ( P ) return w [ P - 40341 ]
end
for P , W in ipairs ( { { 1 , 750 } ;
{ 1 ;
296 } , { 297 , 750 } } ) do
    while W [ 1 ] < W [ 2 ] do
        w [ W [ 1 ] ] , w [ W [ 2 ] ] , W [ 1 ] , W [ 2 ] = w [ W [ 2 ] ] , w [ W [ 1 ] ] , W [ 1 ] + 1 , W [ 2 ] - 1
    end
end do
    local P = string . sub local W = string . len local b = table . insert local n = table . concat local M = w local X = { [ "=" ] = 64 ;
    [ "1" ] = 61 , H = 78 ;
    p = 46 ;
    s = 50 , V = 65 ;
    A = 53 ;
    Z = 33 ;
    [ "*" ] = 24 ;
    t = 84 , U = 62 ;
    [ "\"" ] = 66 ;
    E = 56 , O = 80 , [ "!" ] = 52 ;
    [ "?" ] = 39 , J = 63 ;
    I = 16 ;
    [ "`" ] = 45 , l = 13 ;
    q = 76 ;
    i = 42 ;
    S = 69 ;
    e = 77 ;
    f = 20 , [ "." ] = 8 ;
    [ "6" ] = 6 ;
    T = 60 ;
    [ ">" ] = 74 , m = 25 ;
    [ ";" ] = 27 , [ "8" ] = 36 ;
    [ "(" ] = 44 , M = 15 ;
    g = 58 ;
    [ "2" ] = 29 , K = 3 ;
    j = 49 , F = 9 , [ "5" ] = 1 , [ "[" ] = 40 ;
    W = 30 ;
    Y = 32 , P = 31 ;
    C = 54 ;
    o = 5 ;
    [ "4" ] = 37 , b = 7 ;
    B = 70 ;
    [ "$" ] = 57 , [ "0" ] = 14 , [ "%" ] = 75 , D = 0 , [ "#" ] = 59 , _ = 51 , X = 11 , N = 10 ;
    [ "+" ] = 22 ;
    G = 43 ;
    [ "7" ] = 79 ;
    [ ":" ] = 17 , R = 26 , [ "^" ] = 12 ;
    [ "/" ] = 48 , [ "-" ] = 72 , [ ")" ] = 21 , [ "\\" ] = 38 ;
    [ "<" ] = 4 ;
    h = 41 ;
    [ "@" ] = 82 ;
    n = 71 ;
    r = 81 , a = 23 ;
    [ "&" ] = 47 , [ "]" ] = 67 , [ "3" ] = 18 , [ "9" ] = 55 , [ "\'" ] = 28 , Q = 83 , d = 2 ;
    [ "," ] = 34 ;
    c = 19 ;
    L = 35 , u = 68 ;
    k = 73 } local Y = string . char local g = math . floor local R = { A = 35 , S = 33 , k = 12 , G = 37 ;
    s = 25 , d = 60 , U = 47 , H = 24 , t = 20 , I = 6 ;
    u = 16 , L = 52 , [ "2" ] = 8 , w = 41 ;
    E = 57 , z = 29 , [ "1" ] = 2 ;
    [ "/" ] = 10 ;
    l = 59 ;
    h = 5 , n = 18 ;
    K = 61 , X = 54 , V = 63 , C = 49 , v = 0 ;
    D = 53 ;
    g = 21 ;
    y = 9 , i = 44 , R = 36 , [ "6" ] = 55 , [ "5" ] = 13 , f = 22 ;
    r = 7 ;
    Z = 1 ;
    c = 50 ;
    [ "0" ] = 32 , m = 30 ;
    T = 3 ;
    F = 42 ;
    B = 17 ;
    b = 56 , q = 4 , j = 28 ;
    P = 43 ;
    [ "+" ] = 62 , [ "7" ] = 40 ;
    p = 34 , o = 14 , [ "9" ] = 39 ;
    [ "3" ] = 45 , x = 19 ;
    [ "4" ] = 27 ;
    O = 11 , J = 46 , Q = 58 ;
    N = 48 ;
    W = 38 , Y = 51 ;
    M = 31 , [ "8" ] = 26 , e = 15 ;
    a = 23 } local h = type for w = 1 , # M , 1 do
        local f = M [ w ] if h ( f ) == "string" then
            local h = P ( f , 1 , 1 ) if h == "J" then
                f = P ( f , 2 ) local X = W ( f ) local h = { } local U = 1 local s = 0 local N = 0 while U <= X do
                    local w = P ( f , U , U ) local W = R [ w ] if W then
                        s = s + W * ( ( 64 ) ^ ( ( ( 3 ) - N ) ) ) N = N + 1 if N == 4 then
                            N = 0 local w = g ( s / 65536 ) local P = g ( ( s % 65536 ) / 256 ) local W = s % 256 b ( h , Y ( w , P , W ) ) s = 0
                        end
                    elseif w == "=" then
                        b ( h , Y ( g ( s / 65536 ) ) ) if U >= X or P ( f , U + 1 , U + 1 ) ~= "=" then
                            b ( h , Y ( g ( ( s % 65536 ) / 256 ) ) )
                        end
                        break
                    end
                    U = U + 1
                end
                M [ w ] = n ( h )
            elseif h == "7" then
                f = P ( f , 2 ) local R = W ( f ) local h = { } local U = 1 while U <= R do
                    local w = ( R - U ) + 1 local W = w >= 5 and - 1605713 or w local n = 0 local M = W > 1 for w = 0 , 4 , 1 do
                        local b if w < W then
                            local W = P ( f , U + w , U + w ) b = X [ W ] if not b then
                                M = false break
                            end
                        else
                            b = 84
                        end
                        n = n * ( 85 ) + b
                    end
                    if M then
                        local w = g ( n / 16777216 ) % 256 local P = g ( n / 65536 ) % 256 local M = g ( n / 256 ) % 256 local X = n % 256 if W == 5 then
                            b ( h , Y ( w , P , M , X ) )
                        elseif W == 4 then
                            b ( h , Y ( w , P , M ) )
                        elseif W == 3 then
                            b ( h , Y ( w , P ) )
                        elseif W == 2 then
                            b ( h , Y ( w ) )
                        end
                    end
                    U = U + W
                end
                M [ w ] = n ( h )
            end
        end
    end
end
return ( function ( Y , n , b , g , X , M , w , s , i , z , U , Q , O , L , f , N , T , h , l , R , V , q , a , B , W , c )
    R , i , q , Q , V , a , s , z , T , W , c , B , l , U , h , O , L , N , f = { } , function ( w , P )
        local b = s ( P ) local n = function ( n , M , X , Y , g , R , h )
            return W ( w , { n , M ;
            X , Y ;
            g ;
            R ;
            h } , P , b )
        end
        return n
    end , function ( w , P )
        local b = s ( P ) local n = function ( n , M , X , Y )
            return W ( w , { n , M ;
            X , Y } , P , b )
        end
        return n
    end , function ( w , P )
        local b = s ( P ) local n = function ( n )
            return W ( w , { n } , P , b )
        end
        return n
    end , function ( w , P )
        local b = s ( P ) local n = function ( n , M , X , Y , g , R )
            return W ( w , { n , M ;
            X ;
            Y , g , R } , P , b )
        end
        return n
    end , function ( w , P )
        local b = s ( P ) local n = function ( n , M , X , Y , g )
            return W ( w , { n , M ;
            X ;
            Y , g } , P , b )
        end
        return n
    end , function ( w )
        for P = 1 , # w , 1 do
            h [ w [ P ] ] = h [ w [ P ] ] + 1
        end
        if n then
            local W = n ( true ) local b = X ( W ) b [ P ( 40819 ) ] , b [ P ( 40603 ) ] , b [ P ( 40736 ) ] = w , N , function ( )
                return - 571738
            end
            return W
        else
            return M ( { } , { [ P ( 40603 ) ] = N , [ P ( 40819 ) ] = w , [ P ( 40736 ) ] = function ( )
                return - 571738
            end } )
        end
    end , function ( w , P )
        local b = s ( P ) local n = function ( n , M )
            return W ( w , { n , M } , P , b )
        end
        return n
    end , function ( w , P )
        local b = s ( P ) local n = function ( ... )
            return W ( w , { ... } , P , b )
        end
        return n
    end , function ( W , n , M , X )
        local aC = { } local r , YR , p , MR , yR , WC , UC , CR , y , iR , H , m , TC , gC , e , hR , sC , d , AR , uR , J , o , j , KR , SR , fC , MC , nR , lR , BR , g , Z , gR , cR , fR , v , QR , mR , qR , F , h , oR , D , ZR , u , FR , TR , eR , T , YC , WR , vR , LR , IR , hC , xR , JR , GR , jR , C , tR , N , wC , RR , U , A , pR , S , dR , NC , XC , XR , G , E , PR , I , bC , K , wR , HR , RC , BC , PC , UR , t , aR , rR , k , x , bR , zR , sR , s , VR , OR , nC , ER , NR , DR , kR while W do
            if 8478064 > W then
                if W < - 5809386 then
                    if W < 1802539 then
                        if W < - 1456742 then
                            if W < 763982 then
                                if 170405 > W then
                                    if - 1972344 > W then
                                        WR , W = 2 , 10901609 F = J [ WR ] WR = R [ x ] y = F == WR bR = y
                                    elseif W < - 1386954 then
                                        W , g = w [ "e9laeFkvZIhGdZ"
                                        --[[P(40615)->[274]]
                                        ] , { }
                                    elseif - 1574129 > W then
                                        g , A , N = "tonumber"
                                        --[[P(40675)->[334]]
                                        , "pcall"
                                        --[[P(40547)->[206]]
                                        , "tostring"
                                        --[[P(40573)->[232]]
                                        W = w [ g ] h = R [ M [ 4 ] ] s = w [ N ] o = q ( 9707508 , { } ) S = w [ A ] A = { S ( o ) } Z , S = { b ( A ) } , 2 T = Z [ S ] N = s ( T ) s = ":(%d*):"
                                        --[[P(40650)->[309]]
                                        U = h ( N , s ) h = { U ( ) } g = W ( b ( h ) ) h = g U = R [ M [ 5 ] ] W , g = U and 1622044 or 16460271 , U
                                    else
                                        U , s , h , A , N , o = n [ 2 ] , n [ 3 ] , n [ 1 ] , "\\xDE\\xD1\\xE5"
                                        --[[P(40464)->[123]]
                                        , "Instance"
                                        --[[P(40636)->[295]]
                                        , 25984866135876 g = w [ N ] T = R [ M [ 1 ] ] Z = R [ M [ 2 ] ] S = Z ( A , o ) N = T [ S ] W = g [ N ] S = U g = W ( h ) N = g g = "pairs"
                                        --[[P(40579)->[238]]
                                        W = w [ g ] A = W W = U and 6102334 or 16710805
                                    end
                                else
                                    if W < 419515 then
                                        T = "r\\x10\\x02o\\x1A\\xCC"
                                        --[[P(40955)->[614]]
                                        g = R [ M [ 1 ] ] U = R [ M [ 2 ] ] s = R [ M [ 3 ] ] Z = 11020785095691 N = s ( T , Z ) h = U [ N ] W = g [ h ] W = W and 14158186 or 9731597
                                    elseif 667237 > W then
                                        W = 1416181 E = B ( E ) G = B ( G ) J = nil r = B ( r ) d = B ( d ) x = B ( x ) H = B ( H )
                                    elseif 714435 > W then
                                        A , S = 614199623966 , " \\x95\\x10\\x90:\\x7F"
                                        --[[P(41079)->[738]]
                                        U = R [ M [ 7 ] ] W = 13396177 N = R [ M [ 3 ] ] T = R [ M [ 4 ] ] Z = T ( S , A ) s = N [ Z ] h = U [ s ] g = h
                                    else
                                        U = "workspace"
                                        --[[P(40974)->[633]]
                                        h = w [ U ] s = R [ M [ 1 ] ] Z , S = "\\xEF\\x13\\x8B9eF\\xA0e\\xC9-\\x16bN"
                                        --[[P(40404)->[63]]
                                        , 35184145891327 N = R [ M [ 2 ] ] T = N ( Z , S ) U = s [ T ] g = h [ U ] U = R [ M [ 1 ] ] s = R [ M [ 2 ] ] Z , T = 7189173865747 , "\\xC7\\xC0\\xFA9\\xBA\\xFA\\xD0\\x8BT\\x8A\\xC8Z"
                                        --[[P(40870)->[529]]
                                        N = s ( T , Z ) h = U [ N ] W = g [ h ] R [ M [ 3 ] ] = W W = 107803
                                    end
                                end
                            else
                                if 940732 > W then
                                    if - 1089957 > W then
                                        W = 15567005
                                    elseif - 1108036 > W then
                                        W = U W = g and 10699380 or 12183390
                                    elseif W < 854405 then
                                        W = 13477644
                                    else
                                        o = 8596491620259 W = R [ M [ 4 ] ] U = .16 h = R [ M [ 1 ] ] T = R [ M [ 2 ] ] Z = R [ M [ 3 ] ] A = "#\\x1D\\x19w\\x1B^\\xEA\\xB2:\\xC3,\\xEE8\\xEA*b"
                                        --[[P(40613)->[272]]
                                        S = Z ( A , o ) e = 11470578996445 N = T [ S ] Z = R [ M [ 5 ] ] v = ")\\xD3\\xF7\\x1F,\\xF84\\xC2"
                                        --[[P(40465)->[124]]
                                        A = R [ M [ 2 ] ] o = R [ M [ 3 ] ] u = o ( v , e ) S = A [ u ] T = Z [ S ] s = { [ N ] = T } g = W ( h , U , s ) U , A = .16 , "\\xE7\\x12\\xDCf\\xF4\\xCEbBx]t."
                                        --[[P(40497)->[156]]
                                        W = R [ M [ 4 ] ] h = R [ M [ 6 ] ] T = R [ M [ 2 ] ] Z = R [ M [ 3 ] ] o = 25662076022445 S = Z ( A , o ) N = T [ S ] T = 1 s = { [ N ] = T } g = W ( h , U , s ) W = 12685973
                                    end
                                else
                                    if W < 1032912 then
                                        W = g and 2387219 or - 3287455
                                    elseif 1124039 > W then
                                        W = 4535225
                                    elseif 1232679 > W then
                                        x = 3828369377014 r = R [ N ] G = R [ U ] E = ";Y\\xAC\\x12\"\\x84\\xF0\\xB9\\xD7q\\x0E\\x94t\\x93"
                                        --[[P(40622)->[281]]
                                        H = G ( E , x ) C = r [ H ] t = u [ C ] C = "Wait"
                                        --[[P(40684)->[343]]
                                        C = t [ C ] C = C ( t ) W , e = 16148928 , C
                                    else
                                        g = "pcall"
                                        --[[P(40547)->[206]]
                                        W = w [ g ] h = c ( 4782842 , { M [ 1 ] } ) g = W ( h ) W , g = w [ "dhPCuPEko2nI"
                                        --[[P(40706)->[365]]
                                        ] , { }
                                    end
                                end
                            end
                        else
                            if W > 1629278 then
                                if 1705881 > W then
                                    if W < - 2476993 then
                                        g = R [ M [ 1 ] ] W = not g W = W and - 12673468 or 14977381
                                    elseif W < 1677476 then
                                        W = o o , A = nil , Z N [ A ] = W A , W = nil , 15525964
                                    elseif W < 1692899 then
                                        U = R [ M [ 2 ] ] s = 213 h = U * s U = 27552854471197 g = h + U h = 35184372088832 W = g % h R [ M [ 2 ] ] = W W = 5464531
                                    else
                                        S , T , A , s = "M,5\\xA1\\x8D"
                                        --[[P(40506)->[165]]
                                        , "syn"
                                        --[[P(40937)->[596]]
                                        , 10349847630547 , "typeof"
                                        --[[P(40601)->[260]]
                                        U = w [ s ] N = w [ T ] s = U ( N ) N = R [ M [ 1 ] ] T = R [ M [ 2 ] ] Z = T ( S , A ) U = N [ Z ] h = s == U g , W = h , h and - 11653148 or 1014331
                                    end
                                else
                                    if W < 1718963 then
                                        K , d = 1 , 6 D = R [ S ] j = D ( K , d ) D , d = "l2"
                                        --[[P(40709)->[368]]
                                        , "l2"
                                        --[[P(40709)->[368]]
                                        w [ D ] = j K = w [ d ] d = 2 D = K > d W = D and 2384354 or - 16135713
                                    elseif 1728669 > W then
                                        t = 23804126407500 u = R [ M [ 4 ] ] v = R [ M [ 5 ] ] I = "\\x89\\xF8 \\xA7\\xCD\\x0F\\xFE\\xE8=g\\x0C\\x9C\\xDD\\x8A\\x81l6\\x8F@)\\xCF\\x80S\\x156\\xA2\\x12\\x85\\x0D\\x99\\xBD\\x1C:\\xB9C>\\xB4\\x7F\\xF7\\xE9\\xA4\\x92>B"
                                        --[[P(40619)->[278]]
                                        e = v ( I , t ) o = u [ e ] W , S = 4847886 , o
                                    elseif W < 1758772 then
                                        s = R [ M [ 1 ] ] T = R [ M [ 2 ] ] A , o = "\\xCA\\xF8Vh\\xB7\\xC9\\xD7=\n\\xA2\n"
                                        --[[P(40845)->[504]]
                                        , 28294454145911 Z = R [ M [ 3 ] ] S = Z ( A , o ) W = 10073132 N = T [ S ] U = s [ N ] s = nil h = U == s g = h
                                    else
                                        fR = R [ hR ] aR = "s\\xBE\\xF4\\xB8]\\xDD"
                                        --[[P(40726)->[385]]
                                        NR = R [ N ] OR = 25760185806555 BR = R [ U ] W = 5437434 TR = BR ( aR , OR ) sR = NR [ TR ] qR = "\\x9F}*J\\xA1\\xE5Q\\x0Cm"
                                        --[[P(40928)->[587]]
                                        NR = R [ x ] aR = R [ N ] OR = R [ U ] zR = 4414755735559 cR = OR ( qR , zR ) BR = "WaitForChild"
                                        --[[P(40461)->[120]]
                                        BR = NR [ BR ] TR = aR [ cR ] BR = BR ( NR , TR ) fR [ sR ] = BR
                                    end
                                end
                            else
                                if W > 1414282 then
                                    if W < 1483984 then
                                        d , p = not K , j + p g = p <= D g = d and g d = p >= D d = K and d g = d or g d = 4108040 W = g and d g = 11934555 W = W or g
                                    elseif 1565032 > W then
                                        W , A = N , "\\xD1\\xBEL[q\\xD1&\\xB2\\x08"
                                        --[[P(40850)->[509]]
                                        s [ W ] = g W = R [ M [ 5 ] ] T = R [ M [ 1 ] ] o = 19578124133276 Z = R [ M [ 2 ] ] S = Z ( A , o ) N = T [ S ] g = { W ( N , s , h ) } g , W = { b ( g ) } , w [ "73FjfkWElA3Y9"
                                        --[[P(40823)->[482]]
                                        ]
                                    elseif W < 1600160 then
                                        A , I = "type"
                                        --[[P(40581)->[240]]
                                        , 7413050281339 S = w [ A ] T = W o = R [ s ] A = S ( o ) e = "\\xF3w\\xB6w\\x96\\x1B"
                                        --[[P(40980)->[639]]
                                        o = R [ M [ 4 ] ] u = R [ M [ 5 ] ] v = u ( e , I ) S = o [ v ] Z = A ~= S W , N = Z and 9978740 or 9255673 , Z
                                    else
                                        s = R [ M [ 6 ] ] U = s == h g , W = U , 16460271
                                    end
                                else
                                    if 1346411 > W then
                                        JR = R [ YR ] r = B ( r ) FR = R [ qR ] YC , XC , gR = "O8\\xCFH\\x8CZ\\x0F\\xB1\\x95"
                                        --[[P(40698)->[357]]
                                        , "\\xF5/Z\\xDD*\\xA8\\xC7\\\\xCD\\xC5:?\\xE0\\xF5\\x05\\xA7c"
                                        --[[P(40719)->[378]]
                                        , nil PC = R [ N ] S = B ( S ) WR = B ( WR ) WC = R [ U ] nC = 14512941161062 bC = WC ( XC , nC ) yR = .45 RR = B ( RR ) wC = PC [ bC ] nC , gC , PC , g = 21532157437738 , 21001516770867 , 0 , { } pR = B ( pR ) mR = { [ wC ] = PC } kR = JR ( FR , yR , mR ) JR = R [ YR ] FR = R [ sR ] qR = B ( qR ) KR = B ( KR ) XC , yR = "\\x11~\\xF3\\xAF\\xE0\\x02\\xA8\\x8E"
                                        --[[P(40880)->[539]]
                                        , .7 PC = R [ N ] WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] bC = "UDim2"
                                        --[[P(40720)->[379]]
                                        WC = w [ bC ] XC = R [ N ] nC = R [ U ] MC = nC ( YC , gC ) v = nil bC = XC [ MC ] gC = 22715082795345 PC = WC [ bC ] bC , e , zR , XC = 0.5 , nil , nil , 0.5 WC = PC ( bC , XC ) mR , bC = { [ wC ] = WC } , "Enum"
                                        --[[P(41057)->[716]]
                                        WC = w [ bC ] W = w [ "ZuLBoNs5JTmU"
                                        --[[P(40355)->[14]]
                                        ] XC = R [ N ] nC = R [ U ] YC = "\\xBBv\\x0F\\xD2\\x85\\xFFc\\x1C9\\x8C-"
                                        --[[P(40812)->[471]]
                                        MC = nC ( YC , gC ) wR = nil bC = XC [ MC ] hR = B ( hR ) jR = B ( jR ) YC = 18948772864631 y = B ( y ) MC = "\\x08)\\x9C\\x80\\\\x824\"\\x03T\\xA5"
                                        --[[P(40352)->[11]]
                                        PC = WC [ bC ] bC = R [ N ] XC = R [ U ] gC = 20372508091662 nC = XC ( MC , YC ) WC = bC [ nC ] wC = PC [ WC ] nC , YC = 5219317942654 , "\\x0By\\xBA!\\x9A\\x80\\x96\\x04D\\xFA\\x16"
                                        --[[P(40653)->[312]]
                                        kR = JR ( FR , yR , mR , wC ) JR = R [ YR ] XC , yR = "\\xEF\\xC00\\xAC\\xBF"
                                        --[[P(40738)->[397]]
                                        , .65 FR = R [ BR ] PC = R [ N ] nR = nil WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] PC = aR ( ) bC , mR = "Enum"
                                        --[[P(41057)->[716]]
                                        , { [ wC ] = PC } WC = w [ bC ] XC = R [ N ] nC = R [ U ] MC = nC ( YC , gC ) bC = XC [ MC ] x = B ( x ) PC = WC [ bC ] bC = R [ N ] MC , YC = "\\x1304\\x15"
                                        --[[P(40498)->[157]]
                                        , 1159796408860 XC = R [ U ] nC = XC ( MC , YC ) QR = B ( QR ) WC = bC [ nC ] wC = PC [ WC ] kR = JR ( FR , yR , mR , wC ) JR = R [ YR ] yR , nC = 0.5 , 24661090512091 FR = R [ cR ] XC = "y\\xB4WR9dJfOhJf\\x17{\\xF2\\xB6\\xC2"
                                        --[[P(40702)->[361]]
                                        Z = B ( Z ) PC = R [ N ] WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] PC = .55 TR = B ( TR ) mR = { [ wC ] = PC } kR = JR ( FR , yR , mR ) DR = B ( DR ) WC , FR = 18230805963049 , "task"
                                        --[[P(40721)->[380]]
                                        kR = w [ FR ] XC , H = "e\\x00x\\x0C\\xDF?\\x15\\xDA\\xDA\\xB4\nu\\xD1\\x95{\\xD5"
                                        --[[P(40419)->[78]]
                                        , nil yR = R [ N ] mR = R [ U ] PC = "^\\xDD\\xEF=W"
                                        --[[P(40403)->[62]]
                                        wC = mR ( PC , WC ) FR = yR [ wC ] JR = kR [ FR ] yR = O ( 2707051 , { dR ;
                                        ZR ;
                                        N ;
                                        U ;
                                        YR , vR , AR } ) o = B ( o ) FR = .2 kR = JR ( FR , yR ) MR = B ( MR ) FR = "task"
                                        --[[P(40721)->[380]]
                                        kR = w [ FR ] yR = R [ N ] mR = R [ U ] WC , PC = 20186019538103 , "M\\xB4)\\x1A"
                                        --[[P(40755)->[414]]
                                        wC = mR ( PC , WC ) UR = nil FR = yR [ wC ] PC = 28603030205447 JR = kR [ FR ] FR , wC , u = .32 , "\\x93]\\xC3\\xF9\\xB1\\xD8u"
                                        --[[P(40840)->[499]]
                                        , nil kR = JR ( FR ) JR = R [ tR ] FR = R [ N ] yR = R [ U ] mR = yR ( wC , PC ) kR = FR [ mR ] FR = 317642 > 1036171 JR [ kR ] = FR PC = 20501309138250 JR = R [ eR ] wC = "\\xEB\\xFF\\xFC\\xFE\\x7F/\\xA3"
                                        --[[P(40534)->[193]]
                                        PR = B ( PR ) ZR = B ( ZR ) NR = B ( NR ) FR = R [ N ] yR = R [ U ] MC = "\\x03\\xA3\\xE1\\xB8\\xA6\\xEC\\xF5\\x8E\\x1C\\x11?m\\xF3\\xB7NH"
                                        --[[P(40375)->[34]]
                                        mR = yR ( wC , PC ) kR = FR [ mR ] FR = 15959612 <= 7467180 JR [ kR ] = FR T = B ( T ) JR = R [ rR ] PC = "\\xEB(H\\xABy\\xBA\\xA2_\\x19\\x08\\xE9\\xDBQ\\x8B\\xB4\\xC6\\x12\\x10F"
                                        --[[P(40664)->[323]]
                                        yR = R [ N ] GR = B ( GR ) WC = 15718355115159 mR = R [ U ] wC = mR ( PC , WC ) FR = yR [ wC ] t = B ( t ) kR = JR ( FR ) wC , PC = "\\xCC\\xB7\\x95\\xF2\\x03[\\x85"
                                        --[[P(40749)->[408]]
                                        , 16795661917837 JR = R [ oR ] FR = R [ N ] yR = R [ U ] mR = yR ( wC , PC ) kR = FR [ mR ] FR , nC = 6713366 < 12928470 , 2612806599872 JR [ kR ] = FR s = B ( s ) PC , wC , E = 35014250299312 , "\\x97\\xCA\\x14\\x81\\x13\\x1D\\xC2"
                                        --[[P(40865)->[524]]
                                        , nil JR = R [ IR ] FR = R [ N ] yR = R [ U ] mR = yR ( wC , PC ) kR = FR [ mR ] lR , FR = nil , 6682192 >= 158883 JR [ kR ] = FR JR = R [ SR ] fR = B ( fR ) PC = 2066140447682 FR = R [ N ] yR = R [ U ] wC , VR = "W$fTan\\xE5"
                                        --[[P(40540)->[199]]
                                        , nil mR = yR ( wC , PC ) kR = FR [ mR ] iR , FR = nil , 15691660 > 7162254 JR [ kR ] = FR AR = B ( AR ) JR = R [ YR ] FR = R [ oR ] yR = .4 PC = R [ N ] WC = R [ U ] bC = WC ( XC , nC ) XC , YC , G = "\\xF3\\xD4a\\xFD\\xB8m\\x98\\xF2\\x0E\\xF36rA\\x18`rhz\\xB5\\x8A\\xAA\\x03"
                                        --[[P(40633)->[292]]
                                        , 7832124542527 , nil wC = PC [ bC ] PC = 0 mR , I = { [ wC ] = PC } , nil kR = JR ( FR , yR , mR ) JR = R [ YR ] yR , nC = .35 , 22544961005826 FR = R [ SR ] PC = R [ N ] WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] PC = 0 mR , XC = { [ wC ] = PC } , "sY-\\xD1\\xD21\\xB7\\xB2$\\x9A\\xF5F\\x8En\\x8A\\x17x\\xCE\\x9F\\xDE\\xBA~"
                                        --[[P(40932)->[591]]
                                        kR = JR ( FR , yR , mR ) nC , yR = 21014913328697 , .35 JR = R [ YR ] C = nil A = B ( A ) FR = R [ IR ] PC = R [ N ] WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] bC = R [ N ] XC = R [ U ] vR = B ( vR ) CR = nil nC = XC ( MC , YC ) WC = bC [ nC ] bC , PC = 0 , 0 mR , nC = { [ wC ] = PC , [ WC ] = bC } , 7733096992273 kR = JR ( FR , yR , mR ) JR = R [ YR ] yR , XC = .35 , "\\x05\\x97\\xBE\\xFD\\x00\\xFA\\xBE\\xA7Vw\\x83\\xCC"
                                        --[[P(40970)->[629]]
                                        FR = R [ uR ] PC = R [ N ] WC = R [ U ] LR = nil bC = WC ( XC , nC ) wC = PC [ bC ] PC = 0 mR = { [ wC ] = PC } kR = JR ( FR , yR , mR ) bC , JR = 22174709737557 , 1135751 >= 7479896 kR = f ( ) R [ kR ] = JR FR = R [ IR ] mR = R [ N ] WC , aR = "\\x00\\x8B3\\xE8\\x14\\xF1\\xDC\\xF1\\x9Es\\x83\\x913S\\xC6\\xD4@"
                                        --[[P(41021)->[680]]
                                        , nil wC = R [ U ] PC = wC ( WC , bC ) yR = mR [ PC ] XR = nil JR = FR [ yR ] yR = O ( 10947362 , { kR , dR , IR , N , U , YR , oR ;
                                        SR ;
                                        uR , sR , BR , OR , cR ;
                                        tR ;
                                        eR , rR ;
                                        xR , J , ER ;
                                        HR } ) J = B ( J ) HR = B ( HR ) SR = B ( SR ) uR = B ( uR ) N = B ( N ) eR = B ( eR ) oR = B ( oR ) kR = B ( kR ) FR = "Connect"
                                        --[[P(40953)->[612]]
                                        tR = B ( tR ) BR = B ( BR ) OR = B ( OR ) FR = JR [ FR ] rR = B ( rR ) sR = B ( sR ) IR = B ( IR ) F = B ( F ) FR = FR ( JR , yR ) dR = B ( dR ) ER = B ( ER ) cR = B ( cR ) xR = B ( xR ) YR = B ( YR ) U = B ( U )
                                    elseif - 2411671 > W then
                                        U = g ( N ) W = T W , g = w [ "PowWLNYYPNXowD"
                                        --[[P(40499)->[158]]
                                        ] , { }
                                    elseif W < 1398897 then
                                        g , W = { } , w [ "0hCoOBmSW4zepX"
                                        --[[P(40969)->[628]]
                                        ]
                                    else
                                        W = 13090432 j = u == e p = j
                                    end
                                end
                            end
                        end
                    else
                        if W < 2604585 then
                            if - 2491461 > W then
                                if W > - 3749157 then
                                    if W < 2072453 then
                                        h = n [ 1 ] g = R [ M [ 1 ] ] W = not g W = W and 3289858 or 11552386
                                    elseif 2201106 > W then
                                        y , W = 1 , 7750219 m = J [ y ] k = m
                                    elseif 2305507 > W then
                                        W = 11740481
                                    else
                                        W = w [ "GHuXLGcWliA9dP"
                                        --[[P(40514)->[173]]
                                        ] g = R [ M [ 19 ] ] T = R [ M [ 4 ] ] o , A = 22747406690656 , "F\\x80\\x03\\x9BC\\x9ER\\x11&\\xAF/\\xFCdSb\\xC6&\\xB8r\\x9E\\xDF|9f'\\x0F\\xEB\\x83\\xA0c\\x93\\x84\\xB4\\xF3\\xFF\\xDB\\xB7\\xA7\\xEB\\xB4\\x98:\\xE4$\\xF9\\x91"
                                        --[[P(40763)->[422]]
                                        Z = R [ M [ 5 ] ] S = Z ( A , o ) N = T [ S ] U = g ( N ) g = { }
                                    end
                                else
                                    if W < 1827382 then
                                        U = R [ M [ 6 ] ] N = R [ M [ 3 ] ] W , S , A = 7653137 , "\\xF9\\x98\\x0D\\xB3;a"
                                        --[[P(40808)->[467]]
                                        , 13533964556446 T = R [ M [ 4 ] ] Z = T ( S , A ) s = N [ Z ] h = U [ s ] g = h
                                    elseif W < 1833502 then
                                        W = 4769426
                                    elseif W < 1900923 then
                                        e , U , p = 2236339700753 , 6 , 24126690683874 W = R [ M [ 5 ] ] g = "NextInteger"
                                        --[[P(40878)->[537]]
                                        g , s , E , h , D = W [ g ] , .94 , 23058715322865 , 3 , 21777660323741 g = g ( W , h , U ) u , h = 5378839103944 , g W = R [ M [ 5 ] ] g , U = "NextNumber"
                                        --[[P(40782)->[441]]
                                        , .06 g , A = W [ g ] , 23848402365281 g = g ( W , U , s ) W = R [ M [ 6 ] ] N = R [ M [ 3 ] ] U , S = g , "\\x99\\xEB!i\\xDB"
                                        --[[P(40402)->[61]]
                                        T = R [ M [ 4 ] ] Z = T ( S , A ) t , o = "t\\xC19"
                                        --[[P(40956)->[615]]
                                        , "\\x95c\\x14\\x95"
                                        --[[P(40741)->[400]]
                                        s = N [ Z ] Z = R [ M [ 3 ] ] S = R [ M [ 4 ] ] v = 1157307253274 A = S ( o , u ) K , u = 19978780206167 , "\\xB4g\\xF0kq\\xCC\\x06(\\xCD,\\xB9\\xCC\\xB0\\x16\\xA6"
                                        --[[P(40510)->[169]]
                                        T = Z [ A ] S = R [ M [ 3 ] ] A = R [ M [ 4 ] ] o = A ( u , v ) C = "\\x16\\xFB\\xF0"
                                        --[[P(41039)->[698]]
                                        Z = S [ o ] A = R [ M [ 3 ] ] v = "\\xAEYc\\xBCt\\xB4\\x10\\xBCU!\\x06"
                                        --[[P(40637)->[296]]
                                        o = R [ M [ 4 ] ] u = o ( v , e ) S = A [ u ] u = "Vector2"
                                        --[[P(40861)->[520]]
                                        o = w [ u ] r = 200872575069 v = R [ M [ 3 ] ] e = R [ M [ 4 ] ] I = e ( t , p ) u = v [ I ] v = 0.5 A = o [ u ] u , t = 0.5 , 6601165655041 o = A ( u , v ) u = R [ M [ 3 ] ] G , I = 9203187519677 , "\\xF3w\\x19\\x00\\x10\\xE3F\\xB5"
                                        --[[P(40345)->[4]]
                                        v = R [ M [ 4 ] ] e = v ( I , t ) A = u [ e ] e = "UDim2"
                                        --[[P(40720)->[379]]
                                        v = w [ e ] I = R [ M [ 3 ] ] t = R [ M [ 4 ] ] p = t ( C , D ) e = I [ p ] u = v [ e ] t , d , j , I , e , C = 7 , "r#\\x01\\x10bL"
                                        --[[P(40606)->[265]]
                                        , "\\xC0\\xFE\\x11T\\x81\\x7FX\\xF5\\x9B\\xBC"
                                        --[[P(40543)->[202]]
                                        , 1 , 0 , 24639655750865 v = u ( U , e , I , t ) e = R [ M [ 3 ] ] I = R [ M [ 4 ] ] p = "\\x8E{\\xAAj"
                                        --[[P(41067)->[726]]
                                        t = I ( p , C ) u = e [ t ] t = "UDim2"
                                        --[[P(40720)->[379]]
                                        I = w [ t ] p = R [ M [ 3 ] ] C = R [ M [ 4 ] ] H = "\\xBCO\\xC3E\\\\xB8"
                                        --[[P(40535)->[194]]
                                        D = C ( j , K ) t = p [ D ] e = I [ t ] D = "\\xD9\\xA0\\xD2\\xA8cx\\x9A\\xB2\\x17 \\xAD\\xB8f\\xDA\\x12w"
                                        --[[P(41002)->[661]]
                                        I = e ( h , h ) j = 39599292434 t = R [ M [ 3 ] ] p = R [ M [ 4 ] ] C = p ( D , j ) e = t [ C ] p = R [ M [ 7 ] ] D = R [ M [ 3 ] ] j = R [ M [ 4 ] ] K = j ( d , r ) C = D [ K ] t = p [ C ] r , K = "\\xB8U\\xB3\\xC8\\xE9\\x0E\\x1C\\x85G\\xF1%3\\xB1\\xD4\\xCB"
                                        --[[P(40436)->[95]]
                                        , "\\xEE\\x8E;O\\xC5}W, \\xE7\\xB6\\x0F\\x83\\xD3wV\\xDB\\x05\\xA6\\xE0\\xB9\\xE7"
                                        --[[P(40383)->[42]]
                                        C = R [ M [ 3 ] ] d = 10739636097929 D = R [ M [ 4 ] ] j = D ( K , d ) p = C [ j ] j = R [ M [ 3 ] ] C = .76 K = R [ M [ 4 ] ] d = K ( r , G ) D = j [ d ] d = R [ M [ 3 ] ] j = 0 r = R [ M [ 4 ] ] G = r ( H , E ) K = d [ G ] d = 2 N = { [ T ] = Z ;
                                        [ S ] = o ;
                                        [ A ] = v , [ u ] = I , [ e ] = t ;
                                        [ p ] = C ;
                                        [ D ] = j ;
                                        [ K ] = d } T = R [ M [ 2 ] ] g = W ( s , N , T ) s = f ( ) R [ s ] = g T = 2.1 W = R [ M [ 8 ] ] N = R [ s ] g = W ( N , h ) N , g = 1.25 , "NextNumber"
                                        --[[P(40782)->[441]]
                                        W = R [ M [ 5 ] ] g = W [ g ] g = g ( W , N , T ) N , p = g , 6374043536280 W = R [ M [ 9 ] ] t = "\\x88\\xFC\\xBE"
                                        --[[P(40451)->[110]]
                                        T = R [ s ] e , v = 30172541679330 , "\\x08=\\x88\\x06%{\\xBD="
                                        --[[P(40486)->[145]]
                                        A = R [ M [ 3 ] ] o = R [ M [ 4 ] ] u = o ( v , e ) S = A [ u ] u = "UDim2"
                                        --[[P(40720)->[379]]
                                        o = w [ u ] v = R [ M [ 3 ] ] e = R [ M [ 4 ] ] I = e ( t , p ) p , e , t = .55 , "NextNumber"
                                        --[[P(40782)->[441]]
                                        , .05 u = v [ I ] I = - 0.05 A = o [ u ] v = R [ M [ 5 ] ] e = v [ e ] e = e ( v , I , t ) v = 0 u = U + e e = R [ M [ 5 ] ] U , t , I = nil , .05 , "NextNumber"
                                        --[[P(40782)->[441]]
                                        I = e [ I ] I = I ( e , t , p ) e , p , t = 0 , 23479956761269 , 12010342716888 o = A ( u , v , I , e ) u = R [ M [ 3 ] ] I = "\\x9F\\xB9\\x9F\\xB5\\xFA\\x8C\\xBBY\\xF6\\xA0\\x1F\\xB1/\\x0E\\xC2+\\x84\\x05tZ\\xA9\\x82"
                                        --[[P(40935)->[594]]
                                        v = R [ M [ 4 ] ] e = v ( I , t ) A = u [ e ] t , u = "2\\xC85\\x1D6\\xA8w\\xF2+\\xFC\\xB0"
                                        --[[P(41034)->[693]]
                                        , 1 Z = { [ S ] = o , [ A ] = u } u = "Enum"
                                        --[[P(41057)->[716]]
                                        o = w [ u ] v = R [ M [ 3 ] ] e = R [ M [ 4 ] ] I = e ( t , p ) u = v [ I ] A = o [ u ] u = R [ M [ 3 ] ] t , I = 30927395076161 , "\\x9F!\\xDBp\\xD6"
                                        --[[P(40809)->[468]]
                                        v = R [ M [ 4 ] ] e = v ( I , t ) o = u [ e ] S = A [ o ] g = W ( T , N , Z , S ) T , o , u = "task"
                                        --[[P(40721)->[380]]
                                        , "\\xBD\\x1Fb\\x18n"
                                        --[[P(40816)->[475]]
                                        , 22986124208591 g = w [ T ] Z = R [ M [ 3 ] ] S = R [ M [ 4 ] ] A = S ( o , u ) T = Z [ A ] W = g [ T ] Z = .05 T = N + Z N , h = nil , nil Z = a ( 197053 , { s , M [ 3 ] ;
                                        M [ 4 ] } ) o = "1\\xA0\\xEC/"
                                        --[[P(40566)->[225]]
                                        g = W ( T , Z ) u , T = 31138669230244 , "task"
                                        --[[P(40721)->[380]]
                                        g = w [ T ] Z = R [ M [ 3 ] ] S = R [ M [ 4 ] ] s = B ( s ) A = S ( o , u ) T = Z [ A ] W = g [ T ] T = .2 g = W ( T ) W = 12746847
                                    else
                                        nC = 23377003817605 JR = R [ YR ] XC , W = "\\x1D\\xB3BH"
                                        --[[P(40971)->[630]]
                                        , 1307566 FR = R [ NR ] yR = .65 PC = R [ N ] WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] PC = 14 mR = { [ wC ] = PC } kR = JR ( FR , yR , mR )
                                    end
                                end
                            else
                                if W < 2516422 then
                                    if 2385786 > W then
                                        K = "tostring"
                                        --[[P(40573)->[232]]
                                        D = w [ K ] r , W = "l1"
                                        --[[P(40370)->[29]]
                                        , 13060438 d = w [ r ] K = D ( d ) D = "l2"
                                        --[[P(40709)->[368]]
                                        w [ D ] = K
                                    elseif 2437100 > W then
                                        h , Z , T = "syn"
                                        --[[P(40937)->[596]]
                                        , 8599508635556 , "f~f\\xA6,{m\\x99X\\x1A6"
                                        --[[P(40414)->[73]]
                                        g = w [ h ] U = R [ M [ 1 ] ] s = R [ M [ 2 ] ] N = s ( T , Z ) h = U [ N ] W = g [ h ] h = R [ M [ 3 ] ] g = W ( h ) W = 1385411
                                    elseif W < - 4544655 then
                                        g , W = { } , w [ "YdHgrh1GdlwAtT"
                                        --[[P(40908)->[567]]
                                        ]
                                    else
                                        s = R [ M [ 2 ] ] T = R [ M [ 3 ] ] W , A , o = 13527837 , "\\xF0\\xC4m8\\xB1T"
                                        --[[P(41007)->[666]]
                                        , 23772463803197 Z = R [ M [ 4 ] ] S = Z ( A , o ) N = T [ S ] U = s [ N ] h = not U g = h
                                    end
                                else
                                    if 2539304 > W then
                                        g = R [ M [ 1 ] ] W = not g W , h , U = W and 6878848 or 13158279 , n [ 1 ] , n [ 2 ]
                                    elseif W < 2573216 then
                                        W = S W , N = Z and 1385256 or 11489013 , Z
                                    elseif 2594959 > W then
                                        W = R [ U ] g = { W } W = w [ "V2xb2o1n69OK"
                                        --[[P(40925)->[584]]
                                        ]
                                    else
                                        W = o u = W W , o = T and 3740949 or 13901963 , T
                                    end
                                end
                            end
                        else
                            if W < 3052926 then
                                if W > 2875199 then
                                    if 2967800 > W then
                                        I = "\\xC1\\x16\\x8F\\xF5\\xAB\\x111\\xFF\tI5\\x01"
                                        --[[P(40718)->[377]]
                                        u = R [ M [ 2 ] ] t , W = 33652734901558 , o v = R [ M [ 3 ] ] p = "O\\xAFd\\x7F\\xEA\\xD0[[^"
                                        --[[P(40988)->[647]]
                                        e = v ( I , t ) G = 30211987355380 o = u [ e ] e = 0 u , v = s or e , W e = R [ M [ 2 ] ] C , j , r = 20710933472684 , 23126829902353 , "\\xC5op\\x9A\\xC4\\x86\\x03\\xD4d\\x12V\\xDF\t\\x9E\\xE9"
                                        --[[P(40876)->[535]]
                                        I = R [ M [ 3 ] ] t = I ( p , C ) v = e [ t ] I , t = W , 1 e = N or t t = R [ M [ 2 ] ] D = "\\xE0\\x8A\\xE4m]\\x9D|\\x0Bx\\xEE\\x8E\\xF0\\xAAI5"
                                        --[[P(40428)->[87]]
                                        p = R [ M [ 3 ] ] C = p ( D , j ) I = t [ C ] D = "Enum"
                                        --[[P(41057)->[716]]
                                        C = w [ D ] j = R [ M [ 2 ] ] K = R [ M [ 3 ] ] d = K ( r , G ) D = j [ d ] d = "\\x8317'0\\xB4"
                                        --[[P(40659)->[318]]
                                        p = C [ D ] D = R [ M [ 2 ] ] j = R [ M [ 3 ] ] r = 15465639762977 K = j ( d , r ) C = D [ K ] t = p [ C ] Z = { [ S ] = A , [ o ] = u ;
                                        [ v ] = e , [ I ] = t } g = { W ( T , Z , h ) } g , W = { b ( g ) } , w [ "xFshwomfbVoq"
                                        --[[P(41025)->[684]]
                                        ]
                                    elseif 2988620 > W then
                                        W , g = w [ "fVbbuNnX61MLFU"
                                        --[[P(41055)->[714]]
                                        ] , { }
                                    elseif W < - 3623848 then
                                        S , Z , h , T = nil , nil , nil , nil g = R [ M [ 20 ] ] A = g ( ) s = B ( s ) g , U , W , N = { } , nil , w [ "TQ3n7eSAILoO"
                                        --[[P(40416)->[75]]
                                        ] , nil
                                    else
                                        s = R [ M [ 1 ] ] o , A = 21355818788568 , "e\\xF6[#=\\xE1\\xAA\\xC2\\xE0\\x02\\xAE\\x14"
                                        --[[P(41058)->[717]]
                                        T = R [ M [ 2 ] ] Z = R [ M [ 3 ] ] S = Z ( A , o ) N = T [ S ] U = s [ N ] s = 7365038 < - 16144344 h = U == s g , W = h , h and 11460488 or 13190025
                                    end
                                else
                                    if 2656183 > W then
                                        A = "6\\xF9\\x9A\\x9C"
                                        --[[P(40802)->[461]]
                                        W = R [ M [ 5 ] ] h = R [ M [ 2 ] ] e , U , o = 3963447052085 , .8 , 18121678512374 T = R [ M [ 3 ] ] Z = R [ M [ 4 ] ] S = Z ( A , o ) N = T [ S ] S = "UDim2"
                                        --[[P(40720)->[379]]
                                        Z = w [ S ] v = "\\xB9\\x9E.\\xF1\\xED\\xE2=BV"
                                        --[[P(40641)->[300]]
                                        A = R [ M [ 3 ] ] o = R [ M [ 4 ] ] u = o ( v , e ) S = A [ u ] v , A = 17233657356121 , .68 T = Z [ S ] I , S = 17956310048937 , .68 Z = T ( S , A ) S = R [ M [ 3 ] ] u = "\\xDC\\x87\\x89\\xB4#*m\\xBA"
                                        --[[P(40864)->[523]]
                                        A = R [ M [ 4 ] ] o = A ( u , v ) e = "\\xB5&\\xE6\\x11\\x95\\xC9\\x92\\xB8\\xC4\\xAA\\x8E}/\\xC9\\x16\\xAB,"
                                        --[[P(40440)->[99]]
                                        T = S [ o ] S = 0 o = R [ M [ 3 ] ] u = R [ M [ 4 ] ] v = u ( e , I ) e = 1706430858010 A = o [ v ] o = 0 s = { [ N ] = Z ;
                                        [ T ] = S ;
                                        [ A ] = o } S = "Enum"
                                        --[[P(41057)->[716]]
                                        Z = w [ S ] A = R [ M [ 3 ] ] o = R [ M [ 4 ] ] v = "\\x14YA\\xF0\\x94j\\x89V\\x9A]\\x89"
                                        --[[P(40425)->[84]]
                                        u = o ( v , e ) S = A [ u ] T = Z [ S ] S = R [ M [ 3 ] ] v = 28652443333662 A = R [ M [ 4 ] ] u = "#\\x00\\xA7\\xAB"
                                        --[[P(40715)->[374]]
                                        o = A ( u , v ) Z = S [ o ] N = T [ Z ] g = W ( h , U , s , N ) W = 11404956
                                    elseif W < 2737773 then
                                        h = R [ M [ 1 ] ] g , W = h , h and 12939389 or 8700592
                                    elseif 2777545 > W then
                                        W = g and 1834373 or - 12236842
                                    else
                                        U = R [ M [ 1 ] ] T , N = 2 , 1 s = U ( N , T ) U = 1 h = s == U g , W = h , h and 12705080 or 7985072
                                    end
                                end
                            else
                                if W > 3360588 then
                                    if 3487573 > W then
                                        W = R [ M [ 1 ] ] g = "Disconnect"
                                        --[[P(40783)->[442]]
                                        g = W [ g ] g = g ( W ) g , W = { } , w [ "p1XJnUbAVMmxXU"
                                        --[[P(40610)->[269]]
                                        ]
                                    elseif W < 3625925 then
                                        WR , m = 1 , W F = J [ WR ] WR = 5171525 > 7277259 y = F == WR W , bR = y and - 1935072 or 10901609 , y
                                    else
                                        h = "workspace"
                                        --[[P(40974)->[633]]
                                        g = w [ h ] Z = 5552344730137 U = R [ M [ 1 ] ] s = R [ M [ 2 ] ] T = "Z\\xADZ\\x05R\\xA6\\xD3\\x07\\xA9v\\xBC\\xF4\\x02"
                                        --[[P(40621)->[280]]
                                        N = s ( T , Z ) h = U [ N ] W = g [ h ] W = W and 736373 or 107803
                                    end
                                else
                                    if W < 3120972 then
                                        W , g = w [ "VDtEmESMOdBH"
                                        --[[P(40417)->[76]]
                                        ] , { }
                                    elseif W < 3224068 then
                                        C = "warn"
                                        --[[P(40734)->[393]]
                                        t = w [ C ] G = R [ N ] H = R [ U ] J , x = 10415686587122 , "C\\x10\\x9E"
                                        --[[P(40409)->[68]]
                                        E = H ( x , J ) r = G [ E ] oR , WR = 26380217708540 , 34226478399041 C = t ( r ) MR , C = "]\\x0C;\\xC2\\xFEy\\x8A"
                                        --[[P(40722)->[381]]
                                        , "game"
                                        --[[P(40378)->[37]]
                                        t = w [ C ] x , BR = "\\xFF\\xF8\t\\xB1~1T"
                                        --[[P(41050)->[709]]
                                        , 18506816119209 G = R [ N ] J = 22431876212941 H = R [ U ] gR , y = "\\xD7<\\x08\\xC3\\xFE\\x844"
                                        --[[P(40841)->[500]]
                                        , 18446715576717 E = H ( x , J ) C , J = "GetService"
                                        --[[P(40672)->[331]]
                                        , "\\x17:R\\xB0\\xA3\\xE5\\xBE\\xF9\\xEA-\\xD9\\xFD"
                                        --[[P(40496)->[155]]
                                        r = G [ E ] C = t [ C ] C = C ( t , r ) r = "game"
                                        --[[P(40378)->[37]]
                                        t = w [ r ] H = R [ N ] r = "GetService"
                                        --[[P(40672)->[331]]
                                        E = R [ U ] r , nR = t [ r ] , 27088934891846 x = E ( J , y ) G = H [ x ] r = r ( t , G ) G = "game"
                                        --[[P(40378)->[37]]
                                        t = f ( ) hR = "\\xB0\\x03B\\xB38&\\x18"
                                        --[[P(40364)->[23]]
                                        R [ t ] = r r = w [ G ] y , F , AR , G = "f>\\xFC\\x93\\xEE\\xE2i\\xE0\\x9C\\xCB"
                                        --[[P(40907)->[566]]
                                        , 17366407470998 , "\\xF5\\xB2'=\\xF3[\\x15\\x07\\x0E\\x1Ag}|\\xDF"
                                        --[[P(40877)->[536]]
                                        , "GetService"
                                        --[[P(40672)->[331]]
                                        G , XR = r [ G ] , 14081792760221 E = R [ N ] x = R [ U ] J = x ( y , F ) H = E [ J ] G = G ( r , H ) H = "game"
                                        --[[P(40378)->[37]]
                                        r = w [ H ] H = "GetService"
                                        --[[P(40672)->[331]]
                                        x = R [ N ] RR = 9968251441697 J = R [ U ] F = "\\x10$\\x05k\\xD6\\xD2\\xC0R"
                                        --[[P(40640)->[299]]
                                        y = J ( F , WR ) E = x [ y ] H , PR = r [ H ] , "\\xBEUJ-\\xACpN\\xB8\\x9D]"
                                        --[[P(40703)->[362]]
                                        H = H ( r , E ) E , LR = "game"
                                        --[[P(40378)->[37]]
                                        , 16103948229962 r = f ( ) TR = "\\x02\\xE4\\x0C\\xC7V\\xF5\\xC3"
                                        --[[P(40472)->[131]]
                                        R [ r ] = H WR , wR = "xZ\\x18\\x89\\xC6^\\xF4GX\\x17\\x8C\\xE0\\xDA\\xEDOA"
                                        --[[P(40765)->[424]]
                                        , 10292019385016 H = w [ E ] J = R [ N ] y = R [ U ] F = y ( WR , wR ) x = J [ F ] E , WR , sR = "GetService"
                                        --[[P(40672)->[331]]
                                        , "\\x08\\x1B0\\xC6*\\x9C\\x08\\x9A\\xD0\\xF8\\xBB"
                                        --[[P(40561)->[220]]
                                        , 2454295594102 E = H [ E ] E = E ( H , x ) wR = 27139736252765 J = R [ N ] y = R [ U ] F = y ( WR , wR ) wR = 18533191344566 x = J [ F ] H = C [ x ] WR = "tM\\xA6\\xA1\\x05\\xC6\\xFE\\x87\\x94?\\xD9p\\xBE\\xD3W\\x82\\x15\\x7F\\xD8d\\xB3\\x06pnP\\x06(#N\\xF1\\x0F\\xBC\\xD8[y\\x15\\xE9\\xC5\\xEC\\x18\n.\\x9D\\xBD }S\\xED+\\x04\\xB4U\\xF4\\x83\\x96>\\xF2^8\\x83\\x19\\x99\\x14\\xCE&\\xBB\\xB6\n\\x93\\xC5;Y\\xDC"
                                        --[[P(40803)->[462]]
                                        x = f ( ) R [ x ] = H J = R [ N ] NR = "p\\x9F\\xA4\\xDF\\xEAF\\xFB"
                                        --[[P(40490)->[149]]
                                        y = R [ U ] F = y ( WR , wR ) H = J [ F ] J = f ( ) R [ J ] = H UR = "]\\x0F\\xED\\xA3r F"
                                        --[[P(40624)->[283]]
                                        F = R [ N ] cR = 31322275133689 WR = R [ U ] wR = WR ( PR , nR ) y = F [ wR ] wR = "Color3"
                                        --[[P(40825)->[484]]
                                        WR = w [ wR ] PR = R [ N ] nR = R [ U ] YR = nR ( MR , XR ) wR = PR [ YR ] PR = 16 F = WR [ wR ] nR , wR , YR = 20 , 20 , "2k\\xD3\\x9A\\x0F\\xB2z"
                                        --[[P(40717)->[376]]
                                        WR = F ( wR , PR , nR ) wR = R [ N ] MR = 31367903967502 PR = R [ U ] nR = PR ( YR , MR ) F = wR [ nR ] nR = "Color3"
                                        --[[P(40825)->[484]]
                                        PR = w [ nR ] YR = R [ N ] MR = R [ U ] XR = MR ( gR , RR ) nR = YR [ XR ] wR = PR [ nR ] nR , YR , MR , XR = 24 , 19 , 24 , "\\xB3\\x84\\xB5\\x08\\xFC\\x92+\\x0B"
                                        --[[P(40891)->[550]]
                                        PR = wR ( nR , YR , MR ) fR = 28419280057265 nR = R [ N ] YR = R [ U ] zR , gR = 2257827628059 , 12401025635982 MR = YR ( XR , gR ) wR = nR [ MR ] MR = "Color3"
                                        --[[P(40825)->[484]]
                                        YR = w [ MR ] XR = R [ N ] gR = R [ U ] RR = gR ( hR , fR ) MR = XR [ RR ] ZR , gR , lR , XR = 13482240825478 , 28 , "ep\\x95r\\xE7\\x88["
                                        --[[P(40483)->[142]]
                                        , 22 nR = YR [ MR ] MR , hR = 28 , 32335369419473 YR = nR ( MR , XR , gR ) MR = R [ N ] RR = "#\\xC0\\xD90\\xFF\\u/"
                                        --[[P(40589)->[248]]
                                        XR = R [ U ] gR = XR ( RR , hR ) nR = MR [ gR ] gR = "Color3"
                                        --[[P(40825)->[484]]
                                        XR = w [ gR ] RR = R [ N ] hR = R [ U ] aR = 6762923478093 fR = hR ( UR , sR ) gR = RR [ fR ] RR , fR = 36 , "\\xC5|\\xC7\\x13\\xB1\\xAD"
                                        --[[P(40512)->[171]]
                                        MR = XR [ gR ] gR , hR = 42 , 43 XR = MR ( gR , RR , hR ) gR = R [ N ] UR , iR = 33401477053633 , "\\x13\\x9BW\\xFF\\x1B\\xF3\\x84\\xF7.\\x1C\n1\\x12\\x03"
                                        --[[P(40676)->[335]]
                                        RR = R [ U ] hR = RR ( fR , UR ) MR = gR [ hR ] hR = "Color3"
                                        --[[P(40825)->[484]]
                                        RR = w [ hR ] fR = R [ N ] UR = R [ U ] sR = UR ( NR , BR ) hR = fR [ sR ] gR = RR [ hR ] fR , sR , UR , hR = 32 , "L\\xD3a\\xEEU\\xF6\\xF0r<\\xD7\\xC2"
                                        --[[P(40638)->[297]]
                                        , 41 , 40 RR = gR ( hR , fR , UR ) hR = R [ N ] NR = 3027820971393 fR = R [ U ] UR = fR ( sR , NR ) gR = hR [ UR ] UR = "Color3"
                                        --[[P(40825)->[484]]
                                        fR = w [ UR ] sR = R [ N ] NR = R [ U ] OR = "\\x119\\xF2\\x97\\x9Cn\\xD4"
                                        --[[P(40559)->[218]]
                                        BR = NR ( TR , aR ) NR = 90 UR = sR [ BR ] hR = fR [ UR ] BR , TR , UR , sR = "\\xDE\\xC1\\x92n\\x89Z"
                                        --[[P(40489)->[148]]
                                        , 23335222979186 , 88 , 70 fR = hR ( UR , sR , NR ) UR = R [ N ] sR = R [ U ] NR = sR ( BR , TR ) hR = UR [ NR ] qR , NR = "\\xFF\\x9C\\xC3\\x19WW5"
                                        --[[P(40787)->[446]]
                                        , "Color3"
                                        --[[P(40825)->[484]]
                                        sR = w [ NR ] BR = R [ N ] TR = R [ U ] aR = TR ( OR , cR ) NR = BR [ aR ] BR = 199 UR = sR [ NR ] NR , TR = 235 , 246 sR = UR ( NR , BR , TR ) NR = R [ N ] aR = "v\\xA5\\x85\\xC2"
                                        --[[P(40453)->[112]]
                                        BR = R [ U ] OR = 12275578852948 TR = BR ( aR , OR ) UR = NR [ TR ] TR = "Color3"
                                        --[[P(40825)->[484]]
                                        BR = w [ TR ] aR = R [ N ] OR = R [ U ] cR = OR ( qR , zR ) VR = "\\xF9\n\\xD5W{\\xD6M"
                                        --[[P(40582)->[241]]
                                        TR = aR [ cR ] NR = BR [ TR ] aR , cR , OR , qR , TR = 229 , "\\xC1\\xF7\\xD6\\xC5\\xED"
                                        --[[P(40617)->[276]]
                                        , 234 , 704498401608 , 233 BR = NR ( TR , aR , OR ) TR = R [ N ] aR = R [ U ] OR = aR ( cR , qR ) QR = 8383730569023 NR = TR [ OR ] OR = "Color3"
                                        --[[P(40825)->[484]]
                                        aR = w [ OR ] cR = R [ N ] qR = R [ U ] zR = qR ( VR , LR ) OR = cR [ zR ] VR , zR = 2219987452937 , "\\xA8@\\xCE\\xCDx"
                                        --[[P(40382)->[41]]
                                        TR = aR [ OR ] cR , OR , qR = 115 , 125 , 126 aR = TR ( OR , cR , qR ) OR = R [ N ] cR = R [ U ] qR = cR ( zR , VR ) TR = OR [ qR ] qR = "Color3"
                                        --[[P(40825)->[484]]
                                        cR = w [ qR ] zR = R [ N ] VR = R [ U ] LR = VR ( lR , QR ) lR = "1\\x95^\\xF9\\x19\\xF1k\\x93\\xD8J\\x0BL"
                                        --[[P(41036)->[695]]
                                        qR = zR [ LR ] OR = cR [ qR ] LR , VR , zR , qR = 32897528167383 , 120 , 120 , 240 cR = OR ( qR , zR , VR ) H = { [ y ] = WR , [ F ] = PR ;
                                        [ wR ] = YR ;
                                        [ nR ] = XR , [ MR ] = RR ;
                                        [ gR ] = fR ;
                                        [ hR ] = sR , [ UR ] = BR ;
                                        [ NR ] = aR , [ TR ] = cR } MR = 31743624559037 y = f ( ) YR = 34151152451102 R [ y ] = H UR , RR = 15398004038658 , 18991128666763 WR = R [ N ] nR = "\\x01\\x9966{\\x0F"
                                        --[[P(40462)->[121]]
                                        wR = R [ U ] gR , XR = 9382466949393 , 29939078395509 PR = wR ( nR , YR ) F = WR [ PR ] wR = R [ N ] PR = R [ U ] hR , YR = 13201421867011 , "\\xE8\\xEF\\xE2\\xC3\\x15.\\x95\\x86\\xB3br\\xA9\\x8FL\\xAD\\xB5\\x1B6\\xB8r\\x0FA\\x92"
                                        --[[P(40631)->[290]]
                                        nR = PR ( YR , MR ) MR = "[\\xCA\\x98q"
                                        --[[P(40790)->[449]]
                                        WR = wR [ nR ] PR = R [ N ] nR = R [ U ] YR = nR ( MR , XR ) cR = 17431888388021 wR = PR [ YR ] TR , XR = "k\tl\\xB0Fq-v\\xB6"
                                        --[[P(41032)->[691]]
                                        , "\\x12\\x9C2+\\x8A\\x92I\\x13\\xBA\\x0D\\\\x1B\\x8B\\xFAS\\xCC\\xE3\\xF5x\\x1C \\x8A\\xAB"
                                        --[[P(40922)->[581]]
                                        nR = R [ N ] YR = R [ U ] MR = YR ( XR , gR ) PR = nR [ MR ] YR = R [ N ] MR = R [ U ] gR = "Mh]$"
                                        --[[P(40991)->[650]]
                                        XR = MR ( gR , RR ) RR = "\\x93\\xAC\\x1BKA\\x15_&\\x98\\xE4\\x1D\\xB1[\\x99 \\xF9\\xA2O\\x8F>!C\\xD4\\x88&W\\x06l"
                                        --[[P(40776)->[435]]
                                        nR = YR [ XR ] MR = R [ N ] XR = R [ U ] gR = XR ( RR , hR ) fR = 23493441252027 YR = MR [ gR ] H = { [ F ] = WR ;
                                        [ wR ] = PR , [ nR ] = YR } F = f ( ) YR = 26748874420391 R [ F ] = H XR , nR , qR = "Cg\\x11"
                                        --[[P(40542)->[201]]
                                        , "\\xFEm\\x16.\\xF9\\x81\\xF6\\xF8\\xC6\\xB5*`\\xE1\\xAA\\xD2g \\xCF\\xE7\\xA6O\\xB3\\xBF\\x08\\x84\\x05\\xF7 \\x9B\\x83\\x01\\xE5\\xAE\\xE3\\x9C/\\xDA\\xF2\\x94\\xCD\\x176"
                                        --[[P(40526)->[185]]
                                        , 26756843401387 WR = R [ N ] wR = R [ U ] PR = wR ( nR , YR ) H = WR [ PR ] PR = "Font"
                                        --[[P(40982)->[641]]
                                        wR = w [ PR ] QR , gR = 24081768147917 , 18033234960589 nR = R [ N ] YR = R [ U ] MR = YR ( XR , gR ) PR = nR [ MR ] hR = "\\xCF\\x1E\\xC3\\xC30\\x84!K\\x06\\x9F"
                                        --[[P(40551)->[210]]
                                        WR = wR [ PR ] MR = "Enum"
                                        --[[P(41057)->[716]]
                                        YR = w [ MR ] XR = R [ N ] gR = R [ U ] RR = gR ( hR , fR ) MR = XR [ RR ] hR = 18704238584325 nR = YR [ MR ] MR = R [ N ] RR = "\\x92\\xB8{\\x0D\\x1C\\xEDF"
                                        --[[P(40516)->[175]]
                                        XR = R [ U ] gR = XR ( RR , hR ) YR = MR [ gR ] PR = nR [ YR ] wR = WR ( H , PR ) nR = "Font"
                                        --[[P(40982)->[641]]
                                        PR = w [ nR ] YR = R [ N ] RR = 1382054216323 MR = R [ U ] gR = "\\x95\\xD2\\xFF"
                                        --[[P(40786)->[445]]
                                        XR = MR ( gR , RR ) nR = YR [ XR ] XR = "Enum"
                                        --[[P(41057)->[716]]
                                        WR = PR [ nR ] MR = w [ XR ] gR = R [ N ] RR = R [ U ] fR = "\\xE3\\xEA\\x00\\xC9x\\xE7p\\xBBr\\x88"
                                        --[[P(40568)->[227]]
                                        hR = RR ( fR , UR ) fR = 32786031344547 XR = gR [ hR ] hR = "\\xE7\\xC8\\xAB\\xE9\\x9Ax"
                                        --[[P(40612)->[271]]
                                        YR = MR [ XR ] XR = R [ N ] gR = R [ U ] RR = gR ( hR , fR ) MR = XR [ RR ] nR = YR [ MR ] sR , OR = 25366255496740 , "Ry\\x99\\xB8"
                                        --[[P(40415)->[74]]
                                        PR = WR ( H , nR ) YR = "Font"
                                        --[[P(40982)->[641]]
                                        WR = f ( ) RR = "\\x97L\\x92"
                                        --[[P(40548)->[207]]
                                        R [ WR ] = PR nR = w [ YR ] hR = 32749958183826 MR = R [ N ] XR = R [ U ] gR = XR ( RR , hR ) YR = MR [ gR ] gR = "Enum"
                                        --[[P(41057)->[716]]
                                        PR = nR [ YR ] XR = w [ gR ] UR = "V%\\xAC\\xE0\\x8D\\x85;\\xA0\\xAB\\xE0"
                                        --[[P(40350)->[9]]
                                        RR = R [ N ] hR = R [ U ] fR = hR ( UR , sR ) gR = RR [ fR ] MR = XR [ gR ] gR = R [ N ] fR = "EPoJ\\xB2\\x90\\x9C]"
                                        --[[P(41072)->[731]]
                                        RR = R [ U ] UR = 10002684875313 hR = RR ( fR , UR ) RR = f ( ) XR = gR [ hR ] YR = MR [ XR ] nR = PR ( H , YR ) hR = O ( 10813121 , { N ;
                                        U ;
                                        x } ) YR = L ( 143757 , { N , U } ) MR = l ( 4628565 , { t , N , U } ) PR = f ( ) XR = V ( 10534076 , { PR , N ;
                                        U } ) R [ PR ] = YR YR = f ( ) gR = V ( 12501617 , { N ;
                                        U , WR ;
                                        y , PR } ) aR , VR = 4435881642001 , "\\x81%X\\xF4l\\xFES\\x92y\\xF0\\xDDa"
                                        --[[P(40766)->[425]]
                                        R [ YR ] = MR MR = f ( ) R [ MR ] = XR zR = 34647868997382 XR = q ( 7791220 , { PR , N , U , y } ) R [ RR ] = hR hR = R [ PR ] sR = R [ N ] NR = R [ U ] BR = NR ( TR , aR ) UR = sR [ BR ] BR = R [ N ] TR = R [ U ] aR = TR ( OR , cR ) cR = "sng\\xCE\\xA3\\xDCPv1\\xFC\\xD8\\xA0"
                                        --[[P(40705)->[364]]
                                        NR = BR [ aR ] TR = R [ N ] aR = R [ U ] OR = aR ( cR , qR ) BR = TR [ OR ] aR = R [ N ] qR = "{\\x0C\\x01\\xC3\\xB9\\xEB\\xE4\\xD3\\x80#\\xE6\\x95\\xAAt"
                                        --[[P(40690)->[349]]
                                        OR = R [ U ] cR = OR ( qR , zR ) TR = aR [ cR ] aR = 5496653 ~= - 18122821 cR = R [ N ] qR = R [ U ] zR = qR ( VR , LR ) OR = cR [ zR ] zR = R [ N ] VR = R [ U ] LR = VR ( lR , QR ) cR = 3270677 < 2143167 qR = zR [ LR ] zR = 999999 LR = R [ N ] lR = R [ U ] QR = lR ( iR , ZR ) iR = "Enum"
                                        --[[P(41057)->[716]]
                                        VR = LR [ QR ] QR = w [ iR ] ZR = R [ N ] SR = R [ U ] vR = SR ( AR , oR ) AR = 12971195226008 iR = ZR [ vR ] lR = QR [ iR ] vR = "\\x06\\xF0\\xAB\\x15\\x13HT"
                                        --[[P(40929)->[588]]
                                        iR = R [ N ] ZR = R [ U ] SR = ZR ( vR , AR ) QR = iR [ SR ] LR = lR [ QR ] sR = { [ NR ] = BR ;
                                        [ TR ] = aR , [ OR ] = cR ;
                                        [ qR ] = zR ;
                                        [ VR ] = LR } NR = nil fR = hR ( UR , sR , NR ) UR = "pcall"
                                        --[[P(40547)->[206]]
                                        hR = f ( ) sR = z ( 1696574 , { N , U ;
                                        hR } ) R [ hR ] = fR fR = w [ UR ] UR = fR ( sR ) UR = "pcall"
                                        --[[P(40547)->[206]]
                                        fR = w [ UR ] sR = c ( 12258718 , { hR , N ;
                                        U , RR } ) UR = fR ( sR ) fR = not UR W = fR and 1782945 or 5437434
                                    elseif 3292684 > W then
                                        W , g = w [ "7CyecOxTmZww"
                                        --[[P(40946)->[605]]
                                        ] , { }
                                    else
                                        U = R [ M [ 1 ] ] h = not U g , W = h , h and 13527837 or 2514604
                                    end
                                end
                            end
                        end
                    end
                else
                    if 5750383 > W then
                        if W < 4686871 then
                            if W < 4136095 then
                                if 3910034 > W then
                                    if W < 3753008 then
                                        S = Z ( U , A , o ) g , W = "Create"
                                        --[[P(40492)->[151]]
                                        , u g = W [ g ] g = g ( W , h , S , s ) W , Z = "Play"
                                        --[[P(40349)->[8]]
                                        , g W , g = Z [ W ] , { Z } W = W ( Z ) W = w [ "E2IE25b8ashv"
                                        --[[P(40852)->[511]]
                                        ]
                                    elseif W < 3766977 then
                                        S , W , v = 255 , { } , 1 R [ M [ 2 ] ] = W g = R [ M [ 3 ] ] N , A , T = g , ""
                                        --[[P(41011)->[670]]
                                        , 35184372088832 g = U % T R [ M [ 4 ] ] = g o = 1 Z = U % S S = 2 T = Z + S R [ M [ 5 ] ] = T Z = # h W , S = 13566339 , ""
                                        --[[P(41011)->[670]]
                                        s [ U ] = S u , S , e = Z , 204 , v v = 0 I = v > e v = o - e
                                    elseif W < - 5214766 then
                                        W , S = N , 7593665662416 s [ W ] = g g = R [ M [ 1 ] ] N = R [ M [ 2 ] ] Z , u , v = "\\x94\\xF7\\xAC\\xFB\\x08\\x1C8n\\x0F\\xBA"
                                        --[[P(40973)->[632]]
                                        , "\\xF0Zh\\x8AD\\x81\\xC3Z\\x01\\xE5"
                                        --[[P(40759)->[418]]
                                        , 33434033110224 T = N ( Z , S ) W = g [ T ] S = R [ M [ 1 ] ] A = R [ M [ 2 ] ] o = A ( u , v ) N = W Z = S [ o ] T = s [ Z ] g , W = T , T and 15050091 or 9088940
                                    else
                                        g , W = { } , w [ "4jyfqip5pGGQ0s"
                                        --[[P(40643)->[302]]
                                        ]
                                    end
                                else
                                    if 4020996 > W then
                                        W = N s [ W ] = g g = R [ M [ 1 ] ] Z , S = "\\xE69\\xF6\\xB3\\x1A9\\x16\\x0E\\xAF\\xF8YC\\xC5\\x86"
                                        --[[P(40488)->[147]]
                                        , 21800113235879 N = R [ M [ 2 ] ] T = N ( Z , S ) W = g [ T ] S = R [ M [ 1 ] ] v , N , u = 9888898945532 , W , "Xl\\x1A\\xE1\\xC0B4v\\xEAD\\xB2\\x101\\xD8"
                                        --[[P(40458)->[117]]
                                        A = R [ M [ 2 ] ] o = A ( u , v ) Z = S [ o ] T = s [ Z ] W , g = T and 12406193 or 6999011 , T
                                    elseif W < 4100044 then
                                        W = R [ M [ 1 ] ] g = "Disconnect"
                                        --[[P(40783)->[442]]
                                        g = W [ g ] g = g ( W ) g , W = { } , w [ "S1SAlDeeEo6yF"
                                        --[[P(40507)->[166]]
                                        ]
                                    elseif W < 4118215 then
                                        H , E , G = 100 , 255 , "math"
                                        --[[P(40389)->[48]]
                                        d = f ( ) R [ d ] = p r = w [ G ] k , G = 2 , "random"
                                        --[[P(40943)->[602]]
                                        g = r [ G ] G = 1 r = g ( G , H ) H = 0 G = f ( ) R [ G ] = r g = R [ S ] r = g ( H , E ) H = f ( ) R [ H ] = r y = "tostring"
                                        --[[P(40573)->[232]]
                                        g = R [ S ] E = 1 x = R [ G ] r = g ( E , x ) E = f ( ) R [ E ] = r J , PR = 1 , 10000 r = R [ S ] x = r ( J , k ) r , wR = 1 , 0 g = x == r k = ":"
                                        --[[P(40468)->[127]]
                                        r = f ( ) x = ":(%d*):"
                                        --[[P(40650)->[309]]
                                        R [ r ] = g m = w [ y ] F = R [ S ] WR = { F ( wR , PR ) } y = m ( b ( WR ) ) m = ":"
                                        --[[P(40468)->[127]]
                                        bR = y .. m g = "gsub"
                                        --[[P(40443)->[102]]
                                        g = t [ g ] J = k .. bR g = g ( t , x , J ) k = "pcall"
                                        --[[P(40547)->[206]]
                                        x = f ( ) R [ x ] = g bR = c ( 2786596 , { S ;
                                        d , v , s , U ;
                                        C , r , x ;
                                        G ;
                                        E , H , o } ) J = w [ k ] k = { J ( bR ) } g = { b ( k ) } J = g g = R [ r ] W = g and 6699141 or 8639192
                                    else
                                        g , W = { U } , w [ "liXRTs2olsq4k"
                                        --[[P(40978)->[637]]
                                        ]
                                    end
                                end
                            else
                                if W > 4375438 then
                                    if 4464343 > W then
                                        W = s and 4883126 or 13438951
                                    elseif W < 4512130 then
                                        g , W = { } , w [ "IQ9PybJ61DbJ"
                                        --[[P(41069)->[728]]
                                        ]
                                    elseif W < 4581895 then
                                        D = 3723159 ~= - 9773117 W = D and 1715189 or 8049325
                                    else
                                        W = R [ M [ 1 ] ] T , N , h , e , I , U , s , A = n [ 5 ] , n [ 4 ] , n [ 1 ] , "\\x89\\xAF\\xEA"
                                        --[[P(40995)->[654]]
                                        , 12456980485800 , n [ 2 ] , n [ 3 ] , "TweenInfo"
                                        --[[P(40354)->[13]]
                                        S = w [ A ] o = R [ M [ 2 ] ] u = R [ M [ 3 ] ] v = u ( e , I ) A = o [ v ] Z = S [ A ] A , o = N , W W = N and 2603855 or 9189264
                                    end
                                else
                                    if 4206234 > W then
                                        T = R [ M [ 3 ] ] g , W = T , 3768888
                                    elseif 4287465 > W then
                                        W = 12746847
                                    elseif 4308744 > W then
                                        W = R [ M [ 1 ] ] S = "M\\xDA`\\x1B"
                                        --[[P(40723)->[382]]
                                        U = R [ M [ 2 ] ] Z , T , o , A = 28070023508751 , "mO\\xA2\\xE0\\x14\\xA9}\\x1F\\x94\\x19"
                                        --[[P(40501)->[160]]
                                        , 23100779866629 , 25777985433315 s = R [ M [ 3 ] ] N = s ( T , Z ) h = U [ N ] N = R [ M [ 2 ] ] T = R [ M [ 3 ] ] Z = T ( S , A ) s = N [ Z ] T = R [ M [ 2 ] ] Z = R [ M [ 3 ] ] A = "g\\xFCs\\xC0\\xE5\\xFDW\\xA3@\\xF6c\\xFCJ\\xAF7\\x02"
                                        --[[P(40688)->[347]]
                                        S = Z ( A , o ) N = T [ S ] Z = R [ M [ 2 ] ] S = R [ M [ 3 ] ] u , o = 34037542354409 , "\\xF5\\x11\\x83\\x00"
                                        --[[P(40917)->[576]]
                                        A = S ( o , u ) T = Z [ A ] Z = 0 U = { [ s ] = N , [ T ] = Z } s = R [ M [ 4 ] ] g = W ( h , U , s ) W = w [ "5HTvOBnLIZWbO1"
                                        --[[P(40541)->[200]]
                                        ] R [ M [ 5 ] ] = g g = { }
                                    else
                                        g = "error"
                                        --[[P(40380)->[39]]
                                        W = w [ g ] h = "Tamper Detected!"
                                        --[[P(40379)->[38]]
                                        g = W ( h ) g , W = { } , w [ "aARN6UAZfjFIw"
                                        --[[P(40470)->[129]]
                                        ]
                                    end
                                end
                            end
                        else
                            if W > 4971980 then
                                if W < 5510961 then
                                    if W < 5237602 then
                                        S , A = T , W g = R [ M [ 19 ] ] W = T and 4847886 or 1722738
                                    elseif W < 5450982 then
                                        cR = 27917757379272 fR = R [ PR ] AR = 2459612710009 BR = R [ N ] LR , VR , aC [ 1 ] = 2622284235973 , 26214868987823 , 5533520677392 TR = R [ U ] OR , zR , ZR = "\\xA7\\x88|r\\x96"
                                        --[[P(41010)->[669]]
                                        , 5773823494784 , "\\x96\\x8Cz\\xC3\\x9Fu\\xBD"
                                        --[[P(40735)->[394]]
                                        aR = TR ( OR , cR ) NR = BR [ aR ] vR = 8446443835229 aR = R [ N ] qR = "3@\\x99\\x1A"
                                        --[[P(40729)->[388]]
                                        OR = R [ U ] cR = OR ( qR , zR ) TR = aR [ cR ] OR = R [ N ] uR , zR = "\\xE2\\x18I"
                                        --[[P(40429)->[88]]
                                        , "\\xA7\\x0E{+\\xB5\\xC2\\x8B\\xFA"
                                        --[[P(40868)->[527]]
                                        cR = R [ U ] qR = cR ( zR , VR ) aR = OR [ qR ] cR = R [ N ] QR , VR , iR = "wy\\x8E?N\\xBC0\\xCDL"
                                        --[[P(40831)->[490]]
                                        , "\\xA9\\xB1\\x8BK"
                                        --[[P(40904)->[563]]
                                        , 33428813774030 qR = R [ U ] HR , SR = "\\x93@\\x9D\\xA2\\x97\\x8C\\x96\\xB4F"
                                        --[[P(40399)->[58]]
                                        , 18350880022881 zR = qR ( VR , LR ) OR = cR [ zR ] zR = "UDim2"
                                        --[[P(40720)->[379]]
                                        qR = w [ zR ] VR = R [ N ] LR = R [ U ] lR = LR ( QR , iR ) zR = VR [ lR ] cR = qR [ zR ] lR , zR , VR = "\\xD3Fo\\x0EC\\xFA\\xDFG\\xAA\\xB2\\x04r3(?\\"
                                        --[[P(40774)->[433]]
                                        , 1 , 1 qR = cR ( zR , VR ) QR = 1848209113948 zR = R [ N ] VR = R [ U ] LR = VR ( lR , QR ) eR , oR = 28840459252853 , "\\x8E\\x1Bn\\xDD\\xA6\\x86\\xEF\\xDB\\xE3\\xF4"
                                        --[[P(40743)->[402]]
                                        cR = zR [ LR ] LR = "Color3"
                                        --[[P(40825)->[484]]
                                        VR = w [ LR ] lR = R [ N ] QR = R [ U ] iR = QR ( ZR , SR ) LR = lR [ iR ] zR = VR [ LR ] iR , ZR , lR , QR , SR , LR = "\\x0B\th\\xEC\\xC1 \\xBA\\x08\\xD3\\xE6S\\xEF2zA\\xAC\\xFB\\x88W\\xA1\\x9D\\x93"
                                        --[[P(40849)->[508]]
                                        , 6199861300039 , 0 , 0 , "\\xBB8\\xB7\\xDC\\x93\\xFCq\\xBEp\\xCBa\\x0Df\\xEB\\x8C"
                                        --[[P(41030)->[689]]
                                        , 0 VR = zR ( LR , lR , QR ) LR = R [ N ] lR = R [ U ] QR = lR ( iR , ZR ) zR = LR [ QR ] QR = R [ N ] iR = R [ U ] LR = 1 ZR = iR ( SR , vR ) lR = QR [ ZR ] QR , ZR = 0 , "\\xAF*>"
                                        --[[P(40599)->[258]]
                                        BR = { [ TR ] = aR , [ OR ] = qR ;
                                        [ cR ] = VR ;
                                        [ zR ] = LR ;
                                        [ lR ] = QR } TR = R [ hR ] sR = fR ( NR , BR , TR ) fR = f ( ) NR = f ( ) VR = "\\x8BA\\xA6b"
                                        --[[P(41078)->[737]]
                                        R [ fR ] = sR TR = c ( 4306263 , { PR , N ;
                                        U , r ;
                                        NR } ) UC , sR = "\\xC4\\x99\\xAAz\\x03\\xAA%\\x96"
                                        --[[P(40442)->[101]]
                                        , nil R [ NR ] = sR zR , KR , NC , lR , BR = 22498940365036 , 24185295268862 , "\\x85 \\\\xCB\\x17L\\xF8"
                                        --[[P(40836)->[495]]
                                        , 3289051891195 , "pcall"
                                        --[[P(40547)->[206]]
                                        sR = w [ BR ] qR , GR , SR = "\\x9D\\xDA\\x90&\t"
                                        --[[P(40881)->[540]]
                                        , 10706433774457 , 18303264661835 BR = sR ( TR ) kR = 24140874755049 sR = R [ PR ] aR = R [ N ] LR = 26730793365663 OR = R [ U ] cR = OR ( qR , zR ) TR = aR [ cR ] cR = R [ N ] qR = R [ U ] IR = 16234789625223 zR = qR ( VR , LR ) QR = 4746456647842 OR = cR [ zR ] qR = R [ N ] zR = R [ U ] LR = "\\xC8\\x13\\x1B\\x12E\\x9B\\xA9\\x8D\\xE6\\xBDW"
                                        --[[P(40400)->[59]]
                                        VR = zR ( LR , lR ) cR = qR [ VR ] lR = "\\x8F}\\xAF\\x1CC\\xEC\\xDF\\x18K\\x031"
                                        --[[P(40344)->[3]]
                                        zR = R [ N ] VR = R [ U ] LR = VR ( lR , QR ) qR = zR [ LR ] LR , DR = "Vector2"
                                        --[[P(40861)->[520]]
                                        , "\\xE4\\xD3\\x7F"
                                        --[[P(40519)->[178]]
                                        VR = w [ LR ] lR = R [ N ] vR = "\\x18m'"
                                        --[[P(40696)->[355]]
                                        QR = R [ U ] iR = QR ( ZR , SR ) LR = lR [ iR ] lR = 0.5 zR = VR [ LR ] iR , ZR , WC , LR = "4S>\\x1C\\xE7<\\xEB\\xC6"
                                        --[[P(40666)->[325]]
                                        , 2752548783361 , 20871772562935 , 0.5 VR = zR ( LR , lR ) LR = R [ N ] lR = R [ U ] QR = lR ( iR , ZR ) zR = LR [ QR ] QR = "UDim2"
                                        --[[P(40720)->[379]]
                                        lR = w [ QR ] ER = 34910935383936 iR = R [ N ] ZR = R [ U ] SR = ZR ( vR , AR ) vR , ZR , dR = 7200660704537 , 0.5 , 18676145758712 QR = iR [ SR ] LR = lR [ QR ] iR , QR , SR = 0 , 0.5 , 18 lR = LR ( QR , iR , ZR , SR ) QR = R [ N ] SR = "\\x88\\xD7\\xB2'"
                                        --[[P(40725)->[384]]
                                        iR = R [ U ] ZR = iR ( SR , vR ) LR = QR [ ZR ] ZR = "UDim2"
                                        --[[P(40720)->[379]]
                                        iR = w [ ZR ] SR = R [ N ] vR = R [ U ] AR = vR ( oR , IR ) oR = 28839830418549 ZR = SR [ AR ] QR = iR [ ZR ] CR , AR , SR , ZR = "U\\xC0\\x1A\\xDD\\x1A\\xED"
                                        --[[P(40843)->[502]]
                                        , "\\xA0\\x13\\x14Ma^\\xD1w\\xB3\\xE8\\xB4G\\xACl\\xF2\\x9E\\xFF\\x93\\xE9\\xD0\\x9Dd"
                                        --[[P(40494)->[153]]
                                        , 275 , 390 iR = QR ( ZR , SR ) ZR = R [ N ] SR = R [ U ] vR = SR ( AR , oR ) QR = ZR [ vR ] ZR = 1 aR = { [ OR ] = cR , [ qR ] = VR , [ zR ] = lR , [ LR ] = iR , [ QR ] = ZR } OR = R [ fR ] BR = sR ( TR , aR , OR ) IR = "g*\\xA9\\xD0c-m\\xD5\\x9F\\xB6"
                                        --[[P(41064)->[723]]
                                        sR = f ( ) R [ sR ] = BR BR = R [ PR ] VR = 20171855946929 OR = R [ N ] cR = R [ U ] zR = "\\xF0\\xE5\\x8D\\x9F\\xE7\\x89\\x00"
                                        --[[P(40911)->[570]]
                                        qR = cR ( zR , VR ) AR = 32124270344815 aR = OR [ qR ] qR = R [ N ] lR , tR = 26584637255771 , 19438838604635 zR = R [ U ] LR , iR = "9c\\xE5\\xEB\\xEA"
                                        --[[P(40997)->[656]]
                                        , 6346284911499 VR = zR ( LR , lR ) cR = qR [ VR ] qR = .88 OR , JR = { [ cR ] = qR } , 26311200534492 cR = R [ sR ] TR = BR ( aR , OR , cR ) vR = 13781374818577 BR = f ( ) OR = f ( ) R [ BR ] = TR TR = f ( ) aR = q ( 11803957 , { N ;
                                        U } ) QR = 20895723415042 R [ TR ] = aR aR = O ( 9726847 , { TR ;
                                        N ;
                                        U } ) cR = O ( 5525436 , { TR , N ;
                                        U } ) R [ OR ] = cR cR = R [ BR ] zR = R [ N ] lR = "\\xF3\\xF6\\xDE$U"
                                        --[[P(40936)->[595]]
                                        VR = R [ U ] LR = VR ( lR , QR ) qR = zR [ LR ] zR = aR ( ) SR = 5739679369840 cR [ qR ] = zR QR , ZR = "\\xDF\\xA5Z\\x95\\xBBD\\xF6Y\\x19o"
                                        --[[P(40674)->[333]]
                                        , "\\xFD9t\\xFD"
                                        --[[P(40570)->[229]]
                                        cR = R [ PR ] VR = R [ N ] LR = R [ U ] lR = LR ( QR , iR ) zR = VR [ lR ] lR = R [ N ] QR = R [ U ] iR = QR ( ZR , SR ) SR = "Lc\\x89)\\xCB\\x19"
                                        --[[P(40945)->[604]]
                                        LR = lR [ iR ] QR = R [ N ] iR = R [ U ] ZR = iR ( SR , vR ) lR = QR [ ZR ] vR = "\\x89/\\xD8sz\\xBE\\xE8\\xA2"
                                        --[[P(41062)->[721]]
                                        iR = R [ N ] ZR = R [ U ] SR = ZR ( vR , AR ) QR = iR [ SR ] SR = "UDim2"
                                        --[[P(40720)->[379]]
                                        ZR = w [ SR ] vR = R [ N ] AR = R [ U ] oR = AR ( IR , eR ) SR = vR [ oR ] iR = ZR [ SR ] oR , SR , vR = "\\xC2\\xDA\\x8C\\xB2"
                                        --[[P(40981)->[640]]
                                        , - 25 , - 25 ZR = iR ( SR , vR ) IR = 12634545067771 SR = R [ N ] vR = R [ U ] AR = vR ( oR , IR ) iR = SR [ AR ] AR = "UDim2"
                                        --[[P(40720)->[379]]
                                        vR = w [ AR ] oR = R [ N ] IR = R [ U ] eR = IR ( uR , tR ) AR = oR [ eR ] SR = vR [ AR ] AR , IR , uR , oR , eR = 1 , 1 , 20386880513301 , 50 , 50 vR = SR ( AR , oR , IR , eR ) eR = "\\x02p\\xE9 3`\\xEFC\\xFB\\x8B\\xB1\\x14\\xEF7\\xBC\\x0F\\xDC\\xDEt.d\\xB1"
                                        --[[P(40530)->[189]]
                                        AR = R [ N ] MC = 23452375116456 oR = R [ U ] IR = oR ( eR , uR ) SR = AR [ IR ] AR , tR = 1 , "\\xA0\\xF9\\xE9e*"
                                        --[[P(40460)->[119]]
                                        IR = R [ N ] eR = R [ U ] pR = 15923596958967 uR = eR ( tR , pR ) oR = IR [ uR ] eR = R [ F ] tR = R [ N ] pR = R [ U ] jR = pR ( CR , KR ) uR = tR [ jR ] yR , jR = "G\\xE9)\\x0C"
                                        --[[P(40854)->[513]]
                                        , "\\xE0\\x88\\xE7\\xDA-\\x85\\xB5*\\xC5\\x0EO"
                                        --[[P(40789)->[448]]
                                        IR = eR [ uR ] uR = R [ N ] CR = 3505773069920 tR = R [ U ] pR = tR ( jR , CR ) eR = uR [ pR ] pR = "Color3"
                                        --[[P(40825)->[484]]
                                        tR = w [ pR ] jR = R [ N ] CR = R [ U ] KR = CR ( DR , dR ) pR = jR [ KR ] uR = tR [ pR ] DR , pR , CR , jR = 26644907978871 , 0 , 0 , 0 tR = uR ( pR , jR , CR ) pR = R [ N ] KR = "gd\\x9CB\\x84\\xD8\\xBB\\xC2w\\xB6;\\x17!\\xC4\\xF5\\xCCF"
                                        --[[P(40692)->[351]]
                                        jR = R [ U ] CR = jR ( KR , DR ) uR = pR [ CR ] dR , pR = "\\x1B|t\\xE4\\xC0\\xBD/\\x9B9"
                                        --[[P(40810)->[469]]
                                        , 1 CR = R [ N ] KR = R [ U ] DR = KR ( dR , GR ) jR = CR [ DR ] dR = "Enum"
                                        --[[P(41057)->[716]]
                                        DR = w [ dR ] GR = R [ N ] rR = R [ U ] xR = rR ( HR , ER ) dR = GR [ xR ] KR = DR [ dR ] dR = R [ N ] HR = 20300366308589 GR = R [ U ] xR = "\\xAF;\\xE1D\\x13"
                                        --[[P(40751)->[410]]
                                        rR = GR ( xR , HR ) DR = dR [ rR ] xR = 30878289721386 CR = KR [ DR ] DR = R [ N ] dR = R [ U ] rR = "\\x8A>~M\\xC2\\x9Cf\\xDB\\x0Eo\\x17"
                                        --[[P(41044)->[703]]
                                        GR = dR ( rR , xR ) KR = DR [ GR ] GR = "Rect"
                                        --[[P(40628)->[287]]
                                        dR = w [ GR ] rR = R [ N ] ER = "\\x9E\\xB6\\xE0"
                                        --[[P(40837)->[496]]
                                        xR = R [ U ] HR = xR ( ER , JR ) GR = rR [ HR ] HR , xR = 450 , 450 DR = dR [ GR ] GR , rR = 49 , 49 dR = DR ( GR , rR , xR , HR ) VR = { [ LR ] = lR , [ QR ] = ZR ;
                                        [ iR ] = vR , [ SR ] = AR ;
                                        [ oR ] = IR , [ eR ] = tR ;
                                        [ uR ] = pR , [ jR ] = CR , [ KR ] = dR } LR = R [ sR ] iR = "O\\x8C\\x12\\xAF\\xC7\\x95 g-^/"
                                        --[[P(40469)->[128]]
                                        qR = cR ( zR , VR , LR ) cR = f ( ) R [ cR ] = qR vR = 1246262362692 qR = R [ PR ] oR , jR , ZR , uR = 29316974900563 , 26170530279322 , 22127801034816 , 32558792899385 LR = R [ N ] lR = R [ U ] QR = lR ( iR , ZR ) VR = LR [ QR ] QR = R [ N ] iR = R [ U ] AR , SR = 26310974320604 , "yk\\x13\\x13"
                                        --[[P(41023)->[682]]
                                        ZR = iR ( SR , vR ) vR = "+\\xE1\\xDD\\xA2?\\x80?\\xFEh\\x11"
                                        --[[P(40474)->[133]]
                                        lR = QR [ ZR ] iR = R [ N ] ZR = R [ U ] DR , eR , KR = 22147848104009 , "\\xACq:\\x97\\xD9T\\x00\\xB4W"
                                        --[[P(41008)->[667]]
                                        , 31784377448912 SR = ZR ( vR , AR ) QR = iR [ SR ] GR , AR = "\\xA5Cg\\xCE\\x82I"
                                        --[[P(40645)->[304]]
                                        , "m\\xA75\\x85"
                                        --[[P(41083)->[742]]
                                        ZR = R [ N ] SR = R [ U ] vR = SR ( AR , oR ) iR = ZR [ vR ] vR = "UDim2"
                                        --[[P(40720)->[379]]
                                        SR = w [ vR ] ER = 30870202578983 AR = R [ N ] oR = R [ U ] IR = oR ( eR , uR ) vR = AR [ IR ] ZR = SR [ vR ] eR , vR , tR , IR , nC , CR , AR = 30725503858659 , 1 , "~ke\\xA2\\xC2\\xE5\\x14\\x11=\\xC3"
                                        --[[P(40412)->[71]]
                                        , "b\\xB2\\xDD\\x19\\xD9\\x1BA\\x9F\\x91\\x0E\\xC9\\x07\\xD3W\\xF2`"
                                        --[[P(41016)->[675]]
                                        , "\\xE9\\xE8\\xEB\\xBB\\x18\\x82\\xBC\\xE34"
                                        --[[P(40745)->[404]]
                                        , "\\xDF\\xDB\\x117\\xBA|^T4\\xBA`\\xF7\\xAC\\xB4\\x12\\xEC"
                                        --[[P(41012)->[671]]
                                        , 1 SR = ZR ( vR , AR ) vR = R [ N ] AR = R [ U ] oR = AR ( IR , eR ) pR = 29239534056751 ZR = vR [ oR ] AR = R [ y ] dR = 24650873531606 IR = R [ N ] eR = R [ U ] uR = eR ( tR , pR ) oR = IR [ uR ] vR = AR [ oR ] oR = R [ N ] uR , pR , rR = "\\xFE\\xB8\n\\xCC\\x8D(R\\x9Ae|\\xF7\\x86\\xE93~"
                                        --[[P(40796)->[455]]
                                        , "C\\x15\\xA6C\\x04\\xB4\\xD8\\xE1=\\x15\"\\x01e.\\x82\\xF8\\xA2"
                                        --[[P(40733)->[392]]
                                        , 11148771267655 IR = R [ U ] HR , tR = 3083686020507 , 34460774842031 eR = IR ( uR , tR ) AR = oR [ eR ] oR = 0 eR = R [ N ] uR = R [ U ] tR = uR ( pR , jR ) IR = eR [ tR ] tR = R [ N ] eR = 1 pR = R [ U ] jR = pR ( CR , KR ) uR = tR [ jR ] tR = 7363921 >= 4393675 LR = { [ lR ] = QR , [ iR ] = SR ;
                                        [ ZR ] = vR ;
                                        [ AR ] = oR , [ IR ] = eR , [ uR ] = tR } lR = R [ sR ] zR = qR ( VR , LR , lR ) lR = 14 qR = f ( ) R [ qR ] = zR zR = R [ MR ] LR = R [ qR ] vR , jR , AR , IR = "5\\xD2\\x11\\x9DV\\x9C"
                                        --[[P(40446)->[105]]
                                        , "\\x1D\\xBC\\xF0"
                                        --[[P(40495)->[154]]
                                        , 34607198437107 , 5769111243390 VR = zR ( LR , lR ) VR = R [ qR ] lR = R [ y ] iR = R [ N ] ZR = R [ U ] SR = ZR ( vR , AR ) QR = iR [ SR ] LR = lR [ QR ] lR , tR , QR = 0 , "\\xB8\\xC8\\x967Y\\x0F\\xC74\\x18D"
                                        --[[P(40944)->[603]]
                                        , 1 zR = XR ( VR , LR , lR , QR ) oR , pR , vR = 17495728758739 , 31277103593700 , 23463765830318 VR = R [ PR ] QR = R [ N ] AR , eR = "\\x04\\xE1'G"
                                        --[[P(40348)->[7]]
                                        , 29203445200158 iR = R [ U ] SR , JR = "\\xF1\\x1F\\xCF\\x0E\\xAB"
                                        --[[P(40687)->[346]]
                                        , "_i\\x02l\\x86"
                                        --[[P(40901)->[560]]
                                        ZR = iR ( SR , vR ) lR = QR [ ZR ] ZR = R [ N ] SR = R [ U ] CR = 22859532347796 vR = SR ( AR , oR ) oR = "%\\x86d\\x9B\\xA4\\x04\\x14X"
                                        --[[P(40732)->[391]]
                                        iR = ZR [ vR ] SR = R [ N ] TC = "\\xEC\\x05\\x94\\xF0\\xD6w"
                                        --[[P(41017)->[676]]
                                        vR = R [ U ] AR = vR ( oR , IR ) ZR = SR [ AR ] vR = R [ N ] AR = R [ U ] IR = "?\\x8C\\xA9$h\\x16\\xE2\\xA8"
                                        --[[P(40456)->[115]]
                                        oR = AR ( IR , eR ) SR = vR [ oR ] oR = "UDim2"
                                        --[[P(40720)->[379]]
                                        AR = w [ oR ] IR = R [ N ] eR = R [ U ] uR = eR ( tR , pR ) oR = IR [ uR ] tR = 2709009499373 vR = AR [ oR ] uR , oR , IR = "\\x05)\\xA3\\xE9"
                                        --[[P(40522)->[181]]
                                        , 0 , 0 AR = vR ( oR , IR ) oR = R [ N ] IR = R [ U ] eR = IR ( uR , tR ) vR = oR [ eR ] eR = "UDim2"
                                        --[[P(40720)->[379]]
                                        IR = w [ eR ] uR = R [ N ] tR = R [ U ] pR = tR ( jR , CR ) eR = uR [ pR ] oR = IR [ eR ] tR , KR , eR , pR , uR = 0 , "\\x93[8"
                                        --[[P(40856)->[515]]
                                        , 1 , 1 , 0 IR = oR ( eR , uR , tR , pR ) jR = 8727276556255 eR = R [ N ] pR = "\\xFF\\xD5+\\x12SC\\xF0z\\x9F\\xF3\\x85\\xE9\\xF1\\xC6\\x90\\xB7"
                                        --[[P(40885)->[544]]
                                        uR = R [ U ] tR = uR ( pR , jR ) oR = eR [ tR ] tR = "Color3"
                                        --[[P(40825)->[484]]
                                        uR = w [ tR ] pR = R [ N ] jR = R [ U ] CR = jR ( KR , DR ) KR = 8062040755882 tR = pR [ CR ] jR = 1 eR = uR [ tR ] tR , pR , CR = 1 , 1 , "\\xC3\\xB4\\xDD\\xAC\\xDC^g3KF\\xBD\\x0BP\\xCE\\xA8\\xD4K\\x93P\\x8Ao\\xCF"
                                        --[[P(40805)->[464]]
                                        uR = eR ( tR , pR , jR ) tR = R [ N ] pR = R [ U ] jR = pR ( CR , KR ) eR = tR [ jR ] DR , tR = "\\xB6,\\x13uXD\\x91\\x0Cl\\xD7[\\x15\\xA6\\x88d"
                                        --[[P(40821)->[480]]
                                        , .93 jR = R [ N ] CR = R [ U ] KR = CR ( DR , dR ) gC = 17325548953475 pR = jR [ KR ] jR = 0 KR = R [ N ] DR = R [ U ] dR = DR ( GR , rR ) CR = KR [ dR ] mR , KR = 3298191345151 , 2 QR = { [ iR ] = ZR ;
                                        [ SR ] = AR ;
                                        [ vR ] = IR , [ oR ] = uR , [ eR ] = tR ;
                                        [ pR ] = jR ;
                                        [ CR ] = KR } iR = R [ qR ] AR = "\\l$\\xE5\\x0B\\x0B\"\\xDD1 "
                                        --[[P(40977)->[636]]
                                        LR = VR ( lR , QR , iR ) VR = a ( 15822282 , { PR , N , U ;
                                        F ;
                                        y , qR } ) iR , CR , oR = "UDim2"
                                        --[[P(40720)->[379]]
                                        , "[\\xC2\\x87\\xB4\\x1A\\x00L\\xD6\\xD4\\xE2"
                                        --[[P(40940)->[599]]
                                        , 15865251142875 QR = w [ iR ] ZR = R [ N ] SR = R [ U ] vR = SR ( AR , oR ) iR = ZR [ vR ] lR = QR [ iR ] ZR , IR , iR = 150 , 11834303157638 , 340 QR = lR ( iR , ZR ) oR , ZR = "\\x86\\xB9\\xD7"
                                        --[[P(40764)->[423]]
                                        , "UDim2"
                                        --[[P(40720)->[379]]
                                        iR = w [ ZR ] SR = R [ N ] vR = R [ U ] AR = vR ( oR , IR ) ZR = SR [ AR ] DR = 10729674232708 lR = iR [ ZR ] SR , IR , AR , ZR , vR , eR = - 20 , 15288077474767 , - 20 , 1 , 0 , 21057188734541 iR = lR ( ZR , SR , vR , AR ) lR , ZR , rR = .87 , 90 , 9051724451959 LR = VR ( QR , iR , lR , ZR ) iR = "UDim2"
                                        --[[P(40720)->[379]]
                                        QR = w [ iR ] oR = 29825244608064 ZR = R [ N ] AR = "\\x95\\xC3\\xC4\\xB0\\x0C\\x04j7\\xDCV"
                                        --[[P(40358)->[17]]
                                        SR = R [ U ] xR = "'\\x86\\xF8\\xB8\"\\x8A\\xE8s)"
                                        --[[P(40532)->[191]]
                                        vR = SR ( AR , oR ) iR = ZR [ vR ] lR = QR [ iR ] iR , ZR , oR = 260 , 110 , "\\xF9Z\\xCA"
                                        --[[P(41028)->[687]]
                                        QR = lR ( iR , ZR ) ZR = "UDim2"
                                        --[[P(40720)->[379]]
                                        iR = w [ ZR ] SR = R [ N ] vR = R [ U ] AR = vR ( oR , IR ) ZR = SR [ AR ] lR = iR [ ZR ] vR , AR , SR , ZR = 1 , 10 , 10 , 0 iR = lR ( ZR , SR , vR , AR ) IR , ZR , lR = 12136601277971 , 270 , .9 LR = VR ( QR , iR , lR , ZR ) uR = 29317142099283 LR = R [ PR ] vR , AR = "\\x06\\xD6\\x18\\xF3\\xC7"
                                        --[[P(41089)->[748]]
                                        , 113696882740 iR = R [ N ] GR = 23712032451361 ZR = R [ U ] oR = "\\xD2X\\xDAi"
                                        --[[P(41042)->[701]]
                                        SR = ZR ( vR , AR ) QR = iR [ SR ] SR = R [ N ] vR = R [ U ] AR = vR ( oR , IR ) ZR = SR [ AR ] jR = 8229332766456 vR = R [ N ] IR = "\\xA8Z\\x0D\\xFF\\xD2\\xCA\\xF2\\xED"
                                        --[[P(40616)->[275]]
                                        AR = R [ U ] oR = AR ( IR , eR ) eR = "\\x01\\x8F\\xB3\\xA8\\x99\\x96\\x0E2"
                                        --[[P(40343)->[2]]
                                        SR = vR [ oR ] AR = R [ N ] oR = R [ U ] IR = oR ( eR , uR ) vR = AR [ IR ] IR = "UDim2"
                                        --[[P(40720)->[379]]
                                        oR = w [ IR ] pR = "6\\xCFiT\\xF1\\xE1 \\x8B\\xD5\\x82"
                                        --[[P(40585)->[244]]
                                        eR = R [ N ] uR = R [ U ] tR = uR ( pR , jR ) pR = 23766198233915 IR = eR [ tR ] AR = oR [ IR ] tR , eR , dR , IR = "\\xA6G\\xC9\\x18"
                                        --[[P(40966)->[625]]
                                        , 22 , 24487752674443 , 24 oR = AR ( IR , eR ) IR = R [ N ] eR = R [ U ] uR = eR ( tR , pR ) AR = IR [ uR ] KR , uR = 16992302341864 , "UDim2"
                                        --[[P(40720)->[379]]
                                        eR = w [ uR ] tR = R [ N ] pR = R [ U ] jR = pR ( CR , KR ) KR = "\\x94\\xBE\\x88\\xE0\\xBF\\"
                                        --[[P(40804)->[463]]
                                        uR = tR [ jR ] CR , tR = 16956609322712 , 54 IR = eR [ uR ] uR = 54 eR = IR ( uR , tR ) uR = R [ N ] jR = "\\x98\\x0C#m\\xC7\\xB5\\xD1\\x8D\\x8E\\xEFR\\x18u\\xDB\\xA3\\x85Y\\xC9\\x0C\\x07Xy"
                                        --[[P(40950)->[609]]
                                        tR = R [ U ] pR = tR ( jR , CR ) IR = uR [ pR ] pR = R [ N ] jR = R [ U ] uR = 1 CR = jR ( KR , DR ) tR = pR [ CR ] pR = 3 iR = { [ ZR ] = SR ;
                                        [ vR ] = oR , [ AR ] = eR , [ IR ] = uR , [ tR ] = pR } eR = "\\x1D\\xDA\\xB4\\xD3\\xCD\\x9B\\x89\\x07\\x10rE\\xCD"
                                        --[[P(40999)->[658]]
                                        ZR = R [ qR ] pR , sC = "_\\x05/"
                                        --[[P(40455)->[114]]
                                        , 26802673840320 lR = LR ( QR , iR , ZR ) iR = 27 jR = 1437784834717 LR = R [ MR ] QR = LR ( lR , iR ) oR = "\\x19\\xE02]\\xBBk"
                                        --[[P(41080)->[739]]
                                        iR = R [ y ] SR = R [ N ] IR = 25054343114130 vR = R [ U ] AR = vR ( oR , IR ) ZR = SR [ AR ] QR = iR [ ZR ] ZR , iR = 2 , 0 LR = XR ( lR , QR , iR , ZR ) IR , oR = 6423110749102 , "'\\xEF\\xD3\\xAB\\x02o\\x9B\\x9D\\xBE\\xAC"
                                        --[[P(40605)->[264]]
                                        QR = R [ PR ] SR = R [ N ] DR = 14565757934206 vR = R [ U ] AR = vR ( oR , IR ) ZR = SR [ AR ] AR = R [ N ] oR = R [ U ] uR = 21878445516747 IR = oR ( eR , uR ) vR = AR [ IR ] IR = "NumberSequence"
                                        --[[P(40652)->[311]]
                                        oR = w [ IR ] eR = R [ N ] uR = R [ U ] KR = "\\xEA\\x98\\xD6"
                                        --[[P(40916)->[575]]
                                        tR = uR ( pR , jR ) IR = eR [ tR ] AR = oR [ IR ] tR = "NumberSequenceKeypoint"
                                        --[[P(41015)->[674]]
                                        uR = w [ tR ] pR = R [ N ] jR = R [ U ] CR = jR ( KR , DR ) tR = pR [ CR ] eR = uR [ tR ] tR , pR = 0 , 0 uR = eR ( tR , pR ) pR = "NumberSequenceKeypoint"
                                        --[[P(41015)->[674]]
                                        tR = w [ pR ] jR = R [ N ] CR = R [ U ] DR = "'\\x91\\x11"
                                        --[[P(40670)->[329]]
                                        KR = CR ( DR , dR ) pR = jR [ KR ] eR = tR [ pR ] jR , pR = .9 , 0.5 tR = eR ( pR , jR ) dR , jR = "\\xC1\\x01."
                                        --[[P(40779)->[438]]
                                        , "NumberSequenceKeypoint"
                                        --[[P(41015)->[674]]
                                        pR = w [ jR ] CR = R [ N ] KR = R [ U ] DR = KR ( dR , GR ) KR = 12213054035511 jR = CR [ DR ] eR = pR [ jR ] jR , CR = 1 , 0 pR = { eR ( jR , CR ) } IR = { uR , tR , b ( pR ) } oR = AR ( IR ) CR , tR , SR = "\\x01\\x1B\\x18\\x8D\\xC2(\\x9B\\x85\\x14\\xB7\\xF0"
                                        --[[P(40513)->[172]]
                                        , 22434968398031 , { [ vR ] = oR } iR = QR ( ZR , SR , LR ) dR , AR , uR = 24092728781779 , "TweenInfo"
                                        --[[P(40354)->[13]]
                                        , "l\\x11g"
                                        --[[P(40965)->[624]]
                                        QR = R [ t ] vR = w [ AR ] DR = 21431007291131 oR = R [ N ] IR = R [ U ] eR = IR ( uR , tR ) AR = oR [ eR ] uR = "Enum"
                                        --[[P(41057)->[716]]
                                        SR = vR [ AR ] eR = w [ uR ] tR = R [ N ] pR = R [ U ] jR = pR ( CR , KR ) AR = 1.15 uR = tR [ jR ] jR = "mf\\xA4>\\xA0\\xEA"
                                        --[[P(40873)->[532]]
                                        IR = eR [ uR ] CR = 6495825595344 uR = R [ N ] tR = R [ U ] pR = tR ( jR , CR ) eR = uR [ pR ] KR , tR = "\\xC0\\x95\\x1E\\x96\\xCEkG\\x83f\\x87@\\xCC\\xFC\\xA2b"
                                        --[[P(40445)->[104]]
                                        , "Enum"
                                        --[[P(41057)->[716]]
                                        oR = IR [ eR ] uR = w [ tR ] pR = R [ N ] jR = R [ U ] CR = jR ( KR , DR ) tR = pR [ CR ] CR , KR = "\\xF62\\x9D"
                                        --[[P(40647)->[306]]
                                        , 22066156431395 eR = uR [ tR ] ZR = "Create"
                                        --[[P(40492)->[151]]
                                        tR = R [ N ] pR = R [ U ] jR = pR ( CR , KR ) uR = tR [ jR ] pR = 26051861622627 IR = eR [ uR ] uR , eR , tR = ")WP:\\x88\\x88\\xB5 "
                                        --[[P(40753)->[412]]
                                        , - 1 , 25710253190852 vR = SR ( AR , oR , IR , eR ) oR = R [ N ] jR = 7114729491697 IR = R [ U ] eR = IR ( uR , tR ) ZR = QR [ ZR ] AR = oR [ eR ] eR , oR , CR = "\\xAD\\x8B\\xD7\t7;|\\x86_u"
                                        --[[P(40910)->[569]]
                                        , 360 , 32401793399536 SR , GR = { [ AR ] = oR } , "x\\xE3\\xB3p\\xB1\\xA5\\x04g\\xBB"
                                        --[[P(41037)->[696]]
                                        ZR = ZR ( QR , iR , vR , SR ) QR = f ( ) R [ QR ] = ZR SR = "Play"
                                        --[[P(40349)->[8]]
                                        ZR = R [ QR ] SR = ZR [ SR ] SR = SR ( ZR ) ZR = R [ PR ] AR = R [ N ] DR = "\\xC2=\\xE1"
                                        --[[P(40454)->[113]]
                                        oR = R [ U ] uR = 11553648416004 IR = oR ( eR , uR ) vR = AR [ IR ] IR = R [ N ] eR = R [ U ] tR = "\\xA30\\xD3\\xDE"
                                        --[[P(40586)->[245]]
                                        uR = eR ( tR , pR ) pR = "#I=\\xC1"
                                        --[[P(41035)->[694]]
                                        oR = IR [ uR ] eR = R [ N ] uR = R [ U ] tR = uR ( pR , jR ) IR = eR [ tR ] jR = "\\x18\\x86\\xF6\\x95\\xA5LS+p6\\xB3"
                                        --[[P(40712)->[371]]
                                        uR = R [ N ] tR = R [ U ] pR = tR ( jR , CR ) wC = "w\\xDC`"
                                        --[[P(40842)->[501]]
                                        eR = uR [ pR ] pR = "Vector2"
                                        --[[P(40861)->[520]]
                                        tR = w [ pR ] jR = R [ N ] CR = R [ U ] KR = CR ( DR , dR ) pR = jR [ KR ] KR , jR = "\\xED\\xD1\\x98\\x85#\\xE1\\xA3\\x84"
                                        --[[P(40829)->[488]]
                                        , 0.5 uR = tR [ pR ] pR , DR = 0.5 , 22979980634572 tR = uR ( pR , jR ) pR = R [ N ] jR = R [ U ] CR = jR ( KR , DR ) uR = pR [ CR ] CR = "UDim2"
                                        --[[P(40720)->[379]]
                                        jR = w [ CR ] KR = R [ N ] DR = R [ U ] dR = DR ( GR , rR ) CR = KR [ dR ] pR = jR [ CR ] KR , CR , dR = 0.5 , 0.5 , "Z\\xD1R\\x9D"
                                        --[[P(40373)->[32]]
                                        jR = pR ( CR , KR ) CR = R [ N ] KR = R [ U ] GR = 18733601301011 DR = KR ( dR , GR ) pR = CR [ DR ] DR = "UDim2"
                                        --[[P(40720)->[379]]
                                        KR = w [ DR ] dR = R [ N ] GR = R [ U ] rR = GR ( xR , HR ) xR = 9165421351083 DR = dR [ rR ] rR = "y\\xDB\\x99\n\\xBB\\xCE\\xF1r"
                                        --[[P(40788)->[447]]
                                        CR = KR [ DR ] DR , dR = .2 , .2 KR = CR ( DR , dR ) DR = R [ N ] dR = R [ U ] GR = dR ( rR , xR ) CR = DR [ GR ] HR = "\\x9CH\\x95\\xBA\\xA31M)\\xF0w\\xA3\\x0F\\xAB\\xE7\\xA0_o\\xA8\\xE7\\x12L\\xE2"
                                        --[[P(40642)->[301]]
                                        GR = R [ N ] DR = - 18 rR = R [ U ] xR = rR ( HR , ER ) dR = GR [ xR ] xR = R [ N ] HR = R [ U ] ER = HR ( JR , kR ) rR = xR [ ER ] GR = 1 HR = R [ F ] JR = R [ N ] kR = R [ U ] PC = 12722700883748 FR = kR ( yR , mR ) ER = JR [ FR ] BC = 17149808189234 xR = HR [ ER ] ER = R [ N ] FR = "Vc.\\x1D\\xF2\\xBD\\xFB\\xE2\\xE2(\\xBC"
                                        --[[P(41031)->[690]]
                                        JR = R [ U ] yR = 3915163240223 kR = JR ( FR , yR ) HR = ER [ kR ] kR = "Color3"
                                        --[[P(40825)->[484]]
                                        JR = w [ kR ] FR = R [ N ] yR = R [ U ] mR = yR ( wC , PC ) kR = FR [ mR ] FR , yR , mR = 1 , 1 , "\\x99\\x154\\xED\\xE0eA\\x17w\\x05\\xEE\\xDBC\\xA2D\\xD4\\xE1"
                                        --[[P(40905)->[564]]
                                        ER = JR [ kR ] kR = 1 JR = ER ( kR , FR , yR ) wC = 20290493687016 kR = R [ N ] FR = R [ U ] yR = FR ( mR , wC ) PC = "\\xFB\\xA2\\xCA\\x13\\x9E\\x95\\xF6\\x11\\xA1"
                                        --[[P(41027)->[686]]
                                        ER = kR [ yR ] kR = 1 yR = R [ N ] mR = R [ U ] wC = mR ( PC , WC ) PC = "Enum"
                                        --[[P(41057)->[716]]
                                        FR = yR [ wC ] wC = w [ PC ] WC = R [ N ] bC = R [ U ] XC = bC ( nC , MC ) PC = WC [ XC ] XC = "\\xCF\\x89\\x81"
                                        --[[P(40564)->[223]]
                                        mR = wC [ PC ] PC = R [ N ] nC = 10160464695931 WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] yR = mR [ wC ] wC = R [ N ] bC = "\\x85\\x15\\xCD\\xE0\\xA4Y"
                                        --[[P(40756)->[415]]
                                        PC = R [ U ] XC = 27294883328422 WC = PC ( bC , XC ) mR = wC [ WC ] wC = 4 AR = { [ oR ] = IR ;
                                        [ eR ] = tR , [ uR ] = jR ;
                                        [ pR ] = KR , [ CR ] = DR ;
                                        [ dR ] = GR , [ rR ] = xR , [ HR ] = JR ;
                                        [ ER ] = kR ;
                                        [ FR ] = yR , [ mR ] = wC } SR = ZR ( vR , AR , lR ) ZR = f ( ) R [ ZR ] = SR tR = 10146448527988 vR = R [ qR ] jR , pR , xR = 11598249547032 , "E9\\xB9\\xEE,\\x9E\\xDF\\x12"
                                        --[[P(40590)->[249]]
                                        , "\\xA4\\xA6o\\xD2\\xDB\\xEF\\xBE\\xFF"
                                        --[[P(40768)->[427]]
                                        oR = R [ N ] uR , GR = "\\x1E\\xA2Y\\xD0\\xB3"
                                        --[[P(40833)->[492]]
                                        , 125909893178 IR = R [ U ] eR = IR ( uR , tR ) ER , dR = 33729039564122 , "\\x7F\\x84\\xAF"
                                        --[[P(40839)->[498]]
                                        AR = oR [ eR ] eR = R [ N ] HR = 15357872757743 uR = R [ U ] tR = uR ( pR , jR ) KR = "*\\x9B\\xD7\\xCBz\\xD5\\x9DQk\\xDE"
                                        --[[P(40678)->[337]]
                                        IR = eR [ tR ] tR = "UDim2"
                                        --[[P(40720)->[379]]
                                        uR = w [ tR ] pR = R [ N ] jR = R [ U ] DR = 6676269157412 CR = jR ( KR , DR ) tR = pR [ CR ] pR = 28 eR = uR [ tR ] tR , KR , CR = 94 , 34634201202431 , "\\xB3\\x93\\xA1x"
                                        --[[P(40807)->[466]]
                                        uR = eR ( tR , pR ) tR = R [ N ] pR = R [ U ] jR = pR ( CR , KR ) eR = tR [ jR ] jR = "UDim2"
                                        --[[P(40720)->[379]]
                                        pR = w [ jR ] CR = R [ N ] KR = R [ U ] DR = KR ( dR , GR ) KR = 0 jR = CR [ DR ] tR = pR [ jR ] DR , CR , jR , dR = 22 , - 118 , 1 , 29111237571827 pR = tR ( jR , CR , KR , DR ) jR = R [ N ] JR , DR , hC = "\\xA6\\x14\\xA8\\xF3\\x83]"
                                        --[[P(40667)->[326]]
                                        , "{\\xCB\\x13\\x87"
                                        --[[P(40576)->[235]]
                                        , 20532554507609 CR = R [ U ] KR = CR ( DR , dR ) tR = jR [ KR ] CR = R [ N ] dR , GR = "\\xE5\\xADf\\x89\\x02\\x1C\\xCE"
                                        --[[P(40993)->[652]]
                                        , 11662883132726 KR = R [ U ] DR = KR ( dR , GR ) jR = CR [ DR ] KR = R [ N ] DR = R [ U ] GR , rR = "\\xCA^\\xEC\\xB1\\xB2\\xC5\\xD9]"
                                        --[[P(41003)->[662]]
                                        , 6621735488523 dR = DR ( GR , rR ) CR = KR [ dR ] KR = 20 dR = R [ N ] mR = 10459907527430 GR = R [ U ] rR = GR ( xR , HR ) DR = dR [ rR ] HR = "\\x06S2\\xF6!tR\\xDB\\xC6|z~ y\\xFAQ\\x84\\xE4!"
                                        --[[P(41047)->[706]]
                                        GR = R [ N ] rR = R [ U ] FR = "U\\xCA\\x15rW"
                                        --[[P(40529)->[188]]
                                        xR = rR ( HR , ER ) dR = GR [ xR ] GR , kR = 0 , 32331988695759 xR = R [ N ] HR = R [ U ] ER = HR ( JR , kR ) rR = xR [ ER ] xR = 3 oR = { [ IR ] = uR ;
                                        [ eR ] = pR ;
                                        [ tR ] = jR , [ CR ] = KR , [ DR ] = nR , [ dR ] = GR ;
                                        [ rR ] = xR } SR = gR ( vR , AR , oR ) pR = 26911521173747 vR = f ( ) R [ vR ] = SR DR , HR = "\\x02a<\\x8A\\x8E-\\xCD\\xDF\\x1B\\x1C"
                                        --[[P(40663)->[322]]
                                        , "\\x05QG)}\\xB5\\x90\\x9A"
                                        --[[P(41046)->[705]]
                                        AR = R [ qR ] nC , wC , CR , ER , tR = "\\xD9\\xB4\\x03\\xC7\\xB3m\\xB0Ov\\xB7\n\\x8D\\xC8\\xD8"
                                        --[[P(40846)->[505]]
                                        , 10240527110816 , 24596529097917 , 30326012753705 , "z\\xCA\\x8A\\xB1\\xB9\\x8C"
                                        --[[P(40780)->[439]]
                                        IR = R [ N ] eR = R [ U ] rR , jR = 13504885774480 , "Z\"\\xC3y\\xC8z\\xC0T"
                                        --[[P(40632)->[291]]
                                        uR = eR ( tR , pR ) oR = IR [ uR ] uR = R [ N ] tR = R [ U ] pR = tR ( jR , CR ) eR = uR [ pR ] pR , dR = "UDim2"
                                        --[[P(40720)->[379]]
                                        , 4262346082240 tR = w [ pR ] xR = 32238487075492 jR = R [ N ] CR = R [ U ] KR = CR ( DR , dR ) DR = 24128942468067 pR = jR [ KR ] uR = tR [ pR ] pR , jR = 94 , 52 tR = uR ( pR , jR ) pR = R [ N ] KR = "\\x87\\xD28@"
                                        --[[P(41045)->[704]]
                                        jR = R [ U ] CR = jR ( KR , DR ) JR = 7161716182278 uR = pR [ CR ] CR = "UDim2"
                                        --[[P(40720)->[379]]
                                        jR = w [ CR ] KR = R [ N ] GR = "\\x02\\xFC\\x9D"
                                        --[[P(40527)->[186]]
                                        DR = R [ U ] dR = DR ( GR , rR ) GR , DR = 27242326733197 , 0 CR = KR [ dR ] pR = jR [ CR ] dR , KR , CR = 16 , - 118 , 1 jR = pR ( CR , KR , DR , dR ) CR = R [ N ] dR = "M&},"
                                        --[[P(40422)->[81]]
                                        KR = R [ U ] DR = KR ( dR , GR ) pR = CR [ DR ] rR = 33180666936410 KR = R [ N ] GR = "\\xB6\\xCA:\\x89\\xC3?\\xBF\\xD4^\\xD0\\x0F\\x88\\x1F^\\x0BP4"
                                        --[[P(40853)->[512]]
                                        DR = R [ U ] dR = DR ( GR , rR ) CR = KR [ dR ] rR = "A\\x13\\xA3\\xF1\\x1F\\x9C\\x18\\x04"
                                        --[[P(40531)->[190]]
                                        DR = R [ N ] dR = R [ U ] GR = dR ( rR , xR ) PC = "\\xC2B\\xA1\\xCFS\\x85\\xC3\\xC3\\x9F|XR\\x9C\\x88"
                                        --[[P(40730)->[389]]
                                        KR = DR [ GR ] DR = 13 GR = R [ N ] rR = R [ U ] xR = rR ( HR , ER ) dR = GR [ xR ] rR = R [ N ] ER = "l\\xAA\\x91\n\\xE6\\xB3\\x03\\x1E\\xD8\\x85"
                                        --[[P(40467)->[126]]
                                        xR = R [ U ] MC = 24072388766665 HR = xR ( ER , JR ) yR = 27924317549259 GR = rR [ HR ] xR = R [ y ] ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) HR = ER [ kR ] rR = xR [ HR ] yR = "\\xDDW\\x00\\xD3\\x93g"
                                        --[[P(40989)->[648]]
                                        HR = R [ N ] FR = 19282515403539 ER = R [ U ] kR , WC = "\\x01\\x83sy\\xF1X\\x99\\x8F<$\\xA5\\xD1\\x89K\\xD9\\x85"
                                        --[[P(40739)->[398]]
                                        , 6348007984012 JR = ER ( kR , FR ) xR = HR [ JR ] JR = R [ N ] kR = R [ U ] FR = kR ( yR , mR ) HR = 1 ER = JR [ FR ] JR = 3 IR = { [ eR ] = tR , [ uR ] = jR , [ pR ] = CR ;
                                        [ KR ] = DR , [ dR ] = wR ;
                                        [ GR ] = rR , [ xR ] = HR , [ ER ] = JR } jR , GR = 31839480789482 , 30750401214447 SR = gR ( AR , oR , IR ) HR = 30419667842901 AR = f ( ) R [ AR ] = SR oR = R [ qR ] pR , rR , CR , kR = "\\xFD\\xC4=\\xC7\\x03:\\xAE\\xBC\\x83\\xABI\\xB2~\\xD3\\xC0sJ0"
                                        --[[P(40363)->[22]]
                                        , "k@R"
                                        --[[P(41052)->[711]]
                                        , "{\\xA3\\xF6\\xBF\\xE33\\xDA\\xBE"
                                        --[[P(40998)->[657]]
                                        , 16313661644204 eR = R [ N ] uR = R [ U ] tR = uR ( pR , jR ) IR = eR [ tR ] KR = 32005216287287 tR = R [ N ] pR = R [ U ] jR = pR ( CR , KR ) uR = tR [ jR ] jR = "UDim2"
                                        --[[P(40720)->[379]]
                                        pR = w [ jR ] JR , dR = 17324743368579 , "\\xB2\\x16\\xCA\\xE3\\x99\\x0D\\xEA\\xB0\\xC4_"
                                        --[[P(40871)->[530]]
                                        CR = R [ N ] KR = R [ U ] DR = KR ( dR , GR ) ER = "\\x98\\xEE\\xD5\\xC7q\\xC7\\x87\\xCC"
                                        --[[P(40959)->[618]]
                                        jR = CR [ DR ] tR = pR [ jR ] CR , DR , dR , xR , jR = 94 , "+\\x1A\\xA9m"
                                        --[[P(40386)->[45]]
                                        , 17526881263585 , 20273219298528 , 24 pR = tR ( jR , CR ) jR = R [ N ] CR = R [ U ] KR = CR ( DR , dR ) tR = jR [ KR ] KR = "UDim2"
                                        --[[P(40720)->[379]]
                                        CR = w [ KR ] DR = R [ N ] dR = R [ U ] GR = dR ( rR , xR ) mR = 29869496940117 KR = DR [ GR ] DR , RC = - 48 , "\\xD3}\\xFE\\x0C"
                                        --[[P(40855)->[514]]
                                        jR = CR [ KR ] KR , dR , xR , GR , YC = 1 , 0 , 9637392486791 , 112 , "\\xF9P\\xCE\\xE5\\x00\\xD0"
                                        --[[P(40553)->[212]]
                                        CR = jR ( KR , DR , dR , GR ) yR , rR = "\\xCF\\xC5.\\x1F"
                                        --[[P(41074)->[733]]
                                        , 5726493821546 KR = R [ N ] DR = R [ U ] GR = "\\xDDD\\xFCS"
                                        --[[P(40793)->[452]]
                                        dR = DR ( GR , rR ) jR = KR [ dR ] rR = "es\\xFD\\x8EZ9\\xCB&E\\x8A\\xED\\xAD\\x10X\\xDA\\xC2+S\\xDD\\x89\\xD7hNW'\\xF2\\x9Fkk@]\\x9F\\xA4b\\xFF\\xCB\\x9E\\xA2\\xEE>\\xC3\\xD8q\\xA7Z\\xCFH\\xEB\\x92\\x89\\xB7g\\xFE\\xFA\\xA0\\xB7\\xD8:\\x81o\\x9CA\\x86h\\xFF\\xB0\\xA7\\xB2.\\xCC\\x92ki\\x10F\\x0D\\x81R\\x12*9\\x8Fz\\xEF\\x8F-l\\x9B\\xC4\\x87:\\xC7X\\x1A\\x19\\x1AD\\xDB'X\\xA7Q\\xA7\\xACzs)\\xFDe{\\x9F\\xB6\\xB0\\xB8\\xE0\\xFC \\xB6\\xD1\\x10\\xC3\\xE9i\\xFEQ\\xD5x\\xF4\\xA8\\xC34\\x14\\xBC\to\\xBD\\x0D\\x96\\x0E@\\x1E\\xEF\t\\xC6C[\\xE8\\x0E\\xF8#\\xD3*\\xC6\\x9F\\x0E\\x83\\x8C),\"\\xEA;\\xEA5@\\x808\\xF0\\x91\\x13qyy\\xDE\\xC85)\\x05\\xE43\\x06\\x8C\\xD8\\xE5\\xCE\\x1B\\x91ET\\xC8\\x85\\xF4Lv\\xD6\\xCD\\xC9Q\\xC6\\xF7\\xDD\\x8A\\xA8?E,\\xDCq\\xC3n\\xF9\\x98\\xC8\\x9B\\x06\\xE79(Z\\x10\\x17jw\\xB9\\xB7\\xB23!\\xAF\\x18\\xE6\\xDC2\\x05\\x8B\\x19y\\xEB\\xB6\\x9CjE\\x9F\\x9A\\xFE\\x0B\\xC5>?\\xE4\\x8B\\x0C\\x82q*\\xE8a\\x9F~Z\\xC2}\\xED\\x91\\xE1\\x8B\\x01,\\x9B/\\x96*]e\\x1B\\xD9\\x80\\xD9^\\x83\\xEE\\xB4\\xA1\\x05\\xDD\\xA2\\xF3\\xE0\\x99\\xAD\\xD9h^\\xE3/\\x86s\\x86W\\xA0O\\x9B\\x80\\xE5\\x8Brm:5^\\xC8\\xD0\\x8F?#u6\\x9D\\x074h\\x7F\\x96\\x1C"
                                        --[[P(40979)->[638]]
                                        DR = R [ N ] dR = R [ U ] GR = dR ( rR , xR ) KR = DR [ GR ] xR = "v\\x19+\\xDE\\xB9\\xFE\\x83\\x17"
                                        --[[P(40941)->[600]]
                                        dR = R [ N ] GR = R [ U ] rR = GR ( xR , HR ) DR = dR [ rR ] dR = 13 rR = R [ N ] xR = R [ U ] HR = xR ( ER , JR ) JR = "\\xE9\\x8C\\x8Ev\\xFA\\xA2J\\x9F\\x10\\xAF"
                                        --[[P(40961)->[620]]
                                        GR = rR [ HR ] xR = R [ N ] HR = R [ U ] ER = HR ( JR , kR ) rR = xR [ ER ] HR = R [ y ] JR = R [ N ] kR = R [ U ] FR = kR ( yR , mR ) yR = 17450653261758 ER = JR [ FR ] xR = HR [ ER ] FR = "\\xCD]\\x90\\x069\\xBC\\xD5\\x99Q\\xC9-#\\xD7@\\x17\\x90"
                                        --[[P(40760)->[419]]
                                        ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) mR = "\\xE8\\xF3\\xE7\\xE1WuS\\xF0\\x84j\\x9E"
                                        --[[P(40987)->[646]]
                                        HR = ER [ kR ] kR = R [ N ] FR = R [ U ] ER = 1 yR = FR ( mR , wC ) JR = kR [ yR ] yR = R [ N ] kR = 13297055 < 14457913 mR = R [ U ] wC = mR ( PC , WC ) FR = yR [ wC ] PC = "Enum"
                                        --[[P(41057)->[716]]
                                        wC = w [ PC ] WC = R [ N ] bC = R [ U ] XC = bC ( nC , MC ) PC = WC [ XC ] mR = wC [ PC ] PC = R [ N ] XC , nC , MC = "\\xC8p["
                                        --[[P(40583)->[242]]
                                        , 25598399884944 , 21220005357209 WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] nC = "\\xE1&\\x03JW\\xBA\\xC1"
                                        --[[P(41051)->[710]]
                                        yR = mR [ wC ] wC = R [ N ] PC = R [ U ] bC , XC = "\\x85\\xD4\\xA0s\\x07\\x0E\\xF7\\x9B1\\xFB"
                                        --[[P(40481)->[140]]
                                        , 4892675442918 WC = PC ( bC , XC ) mR = wC [ WC ] wC = 1.12 WC = R [ N ] bC = R [ U ] XC = bC ( nC , MC ) PC = WC [ XC ] XC = R [ N ] WC = 8929142 >= 16668630 nC = R [ U ] MC = nC ( YC , gC ) bC = XC [ MC ] XC = 3 eR = { [ uR ] = pR , [ tR ] = CR , [ jR ] = KR ;
                                        [ DR ] = dR , [ GR ] = wR ;
                                        [ rR ] = xR ;
                                        [ HR ] = ER ;
                                        [ JR ] = kR , [ FR ] = yR ;
                                        [ mR ] = wC ;
                                        [ PC ] = WC ;
                                        [ bC ] = XC } KR = "\\xC6_\\xE4\\x00"
                                        --[[P(40557)->[216]]
                                        SR = gR ( oR , IR , eR ) JR , MC , FR , DR , dR = 4863833196760 , 15035257527129 , 11428130346185 , 25482351439450 , 6270119332711 oR = f ( ) R [ oR ] = SR jR = "\\xC8\\xE1\\xD3\\x92m"
                                        --[[P(40883)->[542]]
                                        SR = R [ PR ] uR = R [ N ] CR = 29489204540835 tR = R [ U ] pR = tR ( jR , CR ) eR = uR [ pR ] HR , kR = 17540306067431 , "n\\xCA\\x0F\\x0E\\xE3\\x1A"
                                        --[[P(40463)->[122]]
                                        pR = R [ N ] jR = R [ U ] CR = jR ( KR , DR ) DR = "X\\x9DCC\\xBAQ\\xFB\\xFE\\xA8\\x88A\\x9BE\\x0C\\xEB\\xD26K"
                                        --[[P(40968)->[627]]
                                        tR = pR [ CR ] jR = R [ N ] ER = "\\xE3|\\xF7"
                                        --[[P(40611)->[270]]
                                        CR = R [ U ] bC = 11659602007349 KR = CR ( DR , dR ) GR , nC = 7809718226484 , 3207005537749 pR = jR [ KR ] dR = "\\xB0\\xE8f\\xFF\\xA2\\xA2\\x80\\xFC"
                                        --[[P(40410)->[69]]
                                        CR = R [ N ] KR = R [ U ] DR = KR ( dR , GR ) WC = 29443259446670 jR = CR [ DR ] DR = "UDim2"
                                        --[[P(40720)->[379]]
                                        KR = w [ DR ] xR = "c\\xF5\\xCE"
                                        --[[P(40656)->[315]]
                                        dR = R [ N ] GR = R [ U ] rR = GR ( xR , HR ) DR = dR [ rR ] CR = KR [ DR ] DR , rR , xR , dR , GR = 0 , - 51 , 4266414163906 , 24 , 1 KR = CR ( DR , dR , GR , rR ) rR , wC , PC = "\\x9B\\xA9\\xF5s"
                                        --[[P(40361)->[20]]
                                        , 21888037873616 , "2\\xEF\\xED\\xD2\\xED\\xEE"
                                        --[[P(41033)->[692]]
                                        DR = R [ N ] dR = R [ U ] GR = dR ( rR , xR ) CR = DR [ GR ] GR = "UDim2"
                                        --[[P(40720)->[379]]
                                        dR = w [ GR ] rR = R [ N ] YC = 32879607364558 xR = R [ U ] HR = xR ( ER , JR ) xR = 0 GR = rR [ HR ] DR = dR [ GR ] ER , GR , HR , rR = 12681946715921 , 1 , 1 , - 48 dR = DR ( GR , rR , xR , HR ) GR = R [ N ] rR = R [ U ] HR = "\\x81\\x9F\\x83p\\x10\\xDB|\\x1A\\xBA\\x94\\x83l\\xA9\\xEA\\x19\\xD1"
                                        --[[P(41048)->[707]]
                                        xR = rR ( HR , ER ) DR = GR [ xR ] rR = R [ y ] HR = R [ N ] ER = R [ U ] JR = ER ( kR , FR ) xR = HR [ JR ] JR = ":\\x1B\\xCC'u1\\x9D\\x1Al\\x00_H/\\xB0\\xB1\\xDCs>\\xF5u\\x9A\\x98"
                                        --[[P(40714)->[373]]
                                        GR = rR [ xR ] yR , kR = 31964462119460 , 32788150762404 xR = R [ N ] HR = R [ U ] ER = HR ( JR , kR ) FR = "\\xD0\\xF6\\xDA\\xDE\\x92.B\\xF3v@\\xEF\\xE4\\x92\\x1E\\x86"
                                        --[[P(40477)->[136]]
                                        rR = xR [ ER ] ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) mR , xR = "~\\x04=\\xB1\\x9E'\\x85"
                                        --[[P(40575)->[234]]
                                        , 1 HR = ER [ kR ] kR = R [ N ] FR = R [ U ] ER = 0 yR = FR ( mR , wC ) JR = kR [ yR ] yR = R [ N ] mR = R [ U ] kR = 504409 > 7255334 wC = mR ( PC , WC ) FR = yR [ wC ] yR = 3 uR , WC = { [ tR ] = pR ;
                                        [ jR ] = KR , [ CR ] = dR ;
                                        [ DR ] = GR ;
                                        [ rR ] = xR , [ HR ] = ER ;
                                        [ JR ] = kR , [ FR ] = yR } , "Rq9\\xCC\\x99\\xAD\\x80\\xC2d\\xD9\\xC6D\\x85\\xDFx"
                                        --[[P(40444)->[103]]
                                        dR = 17454066982847 tR = R [ qR ] IR = SR ( eR , uR , tR ) DR = "\\x11\\xDE^\\x98"
                                        --[[P(40438)->[97]]
                                        SR = f ( ) R [ SR ] = IR IR = R [ PR ] JR , KR = "AD\\xB3"
                                        --[[P(40710)->[369]]
                                        , 28785306301532 tR = R [ N ] XC , yR , CR = "\\x7F\\x87\\x95\\xE2"
                                        --[[P(40926)->[585]]
                                        , 2552450647204 , "\\x141^\\x9D\\xD4\\xCEd\\x81\\x8E\\x04"
                                        --[[P(40669)->[328]]
                                        pR = R [ U ] wC = 22771585345899 jR = pR ( CR , KR ) rR , HR = 13874153511228 , "\\x97\\xCB\\xF4"
                                        --[[P(40716)->[375]]
                                        uR = tR [ jR ] jR = R [ N ] CR = R [ U ] KR = CR ( DR , dR ) kR = 9109449248913 pR = jR [ KR ] CR = R [ N ] KR = R [ U ] dR , GR = "\\x16G\\xFCi\\xA3\\x0E\\xBA.\\x04\n\\xE3\\xBC\\xDC\\x98\\x7F\\x8A"
                                        --[[P(40920)->[579]]
                                        , 11785768605040 DR = KR ( dR , GR ) GR = "\\xE7\\xD5\\xB3\\x84\\x9Eg\\xE0\\x97\\xB6\\x14\\xD8"
                                        --[[P(40990)->[649]]
                                        jR = CR [ DR ] KR = R [ N ] DR = R [ U ] dR = DR ( GR , rR ) CR = KR [ dR ] dR , ER = "Vector2"
                                        --[[P(40861)->[520]]
                                        , 23180560804394 DR = w [ dR ] GR = R [ N ] rR = R [ U ] xR = rR ( HR , ER ) dR = GR [ xR ] KR = DR [ dR ] GR , dR = 1 , 1 DR = KR ( dR , GR ) xR = "\\xB0\\x9AI\\x8E\\x18\\x95X\\xC1"
                                        --[[P(40359)->[18]]
                                        dR = R [ N ] GR = R [ U ] HR = 21423161091831 rR = GR ( xR , HR ) KR = dR [ rR ] rR = "UDim2"
                                        --[[P(40720)->[379]]
                                        GR = w [ rR ] xR = R [ N ] HR = R [ U ] ER = HR ( JR , kR ) mR , HR = "l\\xF4\\xDC'\\xDEQ\\xF9p"
                                        --[[P(40918)->[577]]
                                        , 1 rR = xR [ ER ] ER , FR = - 14 , "\\xF9c\\x89\\xEB\\xFF\\xB9`UQ\\xE8"
                                        --[[P(41040)->[699]]
                                        dR = GR [ rR ] rR , xR = 1 , - 24 GR = dR ( rR , xR , HR , ER ) rR = R [ N ] xR = R [ U ] PC , ER , JR = 10142582067827 , "\\x89\\xE7\\x94\\x7F"
                                        --[[P(40607)->[266]]
                                        , 5320932067757 HR = xR ( ER , JR ) dR = rR [ HR ] HR = "UDim2"
                                        --[[P(40720)->[379]]
                                        xR = w [ HR ] ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) HR = ER [ kR ] rR = xR [ HR ] HR , ER , FR , kR = 112 , 32 , 3794574083814 , "\\x8BF76\\xFCp`\\xBAc@\\x96\\xAB\\]iY"
                                        --[[P(40744)->[403]]
                                        xR = rR ( HR , ER ) HR = R [ N ] ER = R [ U ] JR = ER ( kR , FR ) rR = HR [ JR ] ER = R [ y ] kR = R [ N ] FR = R [ U ] yR = FR ( mR , wC ) mR = 12792977758021 JR = kR [ yR ] HR = ER [ JR ] wC = "\\x80o\\xEC$\\xD7\\x81\\x1F\"A\\xF3\\xDB\\x83P\\x10s"
                                        --[[P(40485)->[144]]
                                        JR = R [ N ] yR , fC = "\\xC0\\xAB@#t\\x19t\\xC0\\x18/\\xBC\\x14G\\xDD\\xE6m\\x9D\\x06\\xBE\\xE5\\xFA\\xAE"
                                        --[[P(41004)->[663]]
                                        , 23177586698792 kR = R [ U ] FR = kR ( yR , mR ) ER = JR [ FR ] JR = 1 FR = R [ N ] yR = R [ U ] mR = yR ( wC , PC ) kR = FR [ mR ] FR = 0 mR = R [ N ] wC = R [ U ] PC = wC ( WC , bC ) yR = mR [ PC ] PC = R [ N ] WC = R [ U ] mR = 16326691 < 8708178 bC = WC ( XC , nC ) wC = PC [ bC ] nC = "\\xF0\\xD53\\xC6/\\xDB\\xFD\\xFA|g"
                                        --[[P(40393)->[52]]
                                        WC = R [ N ] bC = R [ U ] XC = bC ( nC , MC ) PC = WC [ XC ] bC = R [ N ] MC = "?\\xE0(\\xE9p\\x16\\xBB\\x14\\xCF;"
                                        --[[P(40662)->[321]]
                                        XC = R [ U ] nC = XC ( MC , YC ) WC = bC [ nC ] XC = R [ y ] MC = R [ N ] YC = R [ U ] gC = YC ( RC , hC ) RC = 9340089962749 nC = MC [ gC ] gC = "@n\\x87\\x97\\x1C\\x87\\x8B\\xC1\\xDF\\xF9\\x81\\xAB\\x15\\x82\\xE4X"
                                        --[[P(40737)->[396]]
                                        bC = XC [ nC ] nC = R [ N ] MC = R [ U ] YC = MC ( gC , RC ) XC = nC [ YC ] hC , nC = "pu\\xF2\\x96*\\xB8y\\xAD"
                                        --[[P(40866)->[525]]
                                        , 1 YC = R [ N ] gC = R [ U ] RC = gC ( hC , fC ) MC = YC [ RC ] YC = 13 RC = R [ N ] hC = R [ U ] fC = hC ( UC , sC ) gC = RC [ fC ] RC = R [ WR ] fC = R [ N ] UC = R [ U ] sC = UC ( NC , BC ) hC = fC [ sC ] sC = R [ N ] NC = R [ U ] fC = 843278 < 350039 BC = NC ( TC , aC [ 1 ] ) UC = sC [ BC ] sC = 4 tR = { [ pR ] = jR ;
                                        [ CR ] = DR ;
                                        [ KR ] = GR , [ dR ] = xR ;
                                        [ rR ] = HR ;
                                        [ ER ] = JR , [ kR ] = FR , [ yR ] = mR ;
                                        [ wC ] = PC , [ WC ] = bC ;
                                        [ XC ] = nC ;
                                        [ MC ] = YC , [ gC ] = RC ;
                                        [ hC ] = fC ;
                                        [ UC ] = sC } dR = "\\xDB\\xCDd\\x06\\xD0\\xB3\\x9E\\x07\\x05\\x8C\\xBB"
                                        --[[P(41005)->[664]]
                                        pR = R [ qR ] kR = 4787699779765 eR = IR ( uR , tR , pR ) IR = f ( ) R [ IR ] = eR eR = R [ MR ] tR = R [ IR ] pR , XC = 8 , "P\\xBC\\x0C\\xBE\\xEC\\xC1"
                                        --[[P(40538)->[197]]
                                        uR = eR ( tR , pR ) GR = 31069088004227 uR = R [ IR ] pR = R [ y ] CR = R [ N ] KR = R [ U ] DR = KR ( dR , GR ) jR = CR [ DR ] tR = pR [ jR ] pR , jR = 1 , 1 eR = XR ( uR , tR , pR , jR ) dR , DR = 22013641402378 , "bZ\\x7F\\xCE\\x02\\x85`\\xC1\\xE0_"
                                        --[[P(40369)->[28]]
                                        uR = f ( ) R [ uR ] = eR tR = R [ IR ] jR = R [ N ] CR = R [ U ] KR = CR ( DR , dR ) pR = jR [ KR ] eR = tR [ pR ] FR = "\\x9C1\\xDD\\xCCd\\x83\\x8A[\\x93\\x7F"
                                        --[[P(40817)->[476]]
                                        pR = Q ( 8043921 , { IR , N , U ;
                                        YR ;
                                        y , uR } ) tR = "Connect"
                                        --[[P(40953)->[612]]
                                        tR , DR , GR = eR [ tR ] , "\\xA4\\xCC\\x7FM$w\\xBE\\xBA;\\x9B"
                                        --[[P(40896)->[555]]
                                        , "\\xB45\\x14\\xB9\\xE8<\\xD8m\\x9A*\\xE4"
                                        --[[P(40769)->[428]]
                                        tR = tR ( eR , pR ) tR = R [ IR ] jR = R [ N ] dR = 29200884118813 CR = R [ U ] JR = "\\xEF\\xD9g"
                                        --[[P(40493)->[152]]
                                        KR = CR ( DR , dR ) pR = jR [ KR ] eR = tR [ pR ] tR = "Connect"
                                        --[[P(40953)->[612]]
                                        tR , dR = eR [ tR ] , 22470645131487 pR = z ( 16764486 , { IR , N , U , YR ;
                                        y ;
                                        uR } ) yR = 190296375384 tR = tR ( eR , pR ) tR = R [ qR ] jR = R [ N ] DR , rR , ER = "G\\x05\\xF2v\\xB1\\xB0M"
                                        --[[P(41085)->[744]]
                                        , 34651139817223 , 11900865009061 CR = R [ U ] KR = CR ( DR , dR ) pR = jR [ KR ] KR = R [ N ] DR = R [ U ] HR = "\\xB2_\\xF5"
                                        --[[P(40500)->[159]]
                                        dR = DR ( GR , rR ) CR = KR [ dR ] dR = "Vector2"
                                        --[[P(40861)->[520]]
                                        DR = w [ dR ] PC = 4034515027798 GR = R [ N ] rR = R [ U ] xR = rR ( HR , ER ) HR = 31580094380401 dR = GR [ xR ] KR = DR [ dR ] dR , GR = 1 , 0 DR = KR ( dR , GR ) dR = R [ N ] nC , xR = 25368135970340 , "O\\xA5\\\\x07\\xA4\\xB6\\xACX"
                                        --[[P(40614)->[273]]
                                        GR = R [ U ] gC = 15801481370814 rR = GR ( xR , HR ) KR = dR [ rR ] rR = "UDim2"
                                        --[[P(40720)->[379]]
                                        GR = w [ rR ] xR = R [ N ] HR = R [ U ] WC = 30453298968420 ER = HR ( JR , kR ) rR = xR [ ER ] HR , JR , ER = 1 , 14453315656266 , - 52 dR = GR [ rR ] rR , xR = 1 , - 24 GR = dR ( rR , xR , HR , ER ) ER = "kS\\xF2?"
                                        --[[P(40942)->[601]]
                                        rR = R [ N ] wC = "\\xBC\\xD6Wc\\xCC:3\\xEE"
                                        --[[P(40775)->[434]]
                                        xR = R [ U ] HR = xR ( ER , JR ) dR = rR [ HR ] HR = "UDim2"
                                        --[[P(40720)->[379]]
                                        xR = w [ HR ] hC = 25945227980593 ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) HR = ER [ kR ] ER = 16 rR = xR [ HR ] kR , yR , FR , HR = "p\\x87'\\x07"
                                        --[[P(41041)->[700]]
                                        , 27246293430671 , 27559285125665 , 60 xR = rR ( HR , ER ) HR = R [ N ] ER = R [ U ] JR = ER ( kR , FR ) rR = HR [ JR ] FR = "\\xF5\\xA7"
                                        --[[P(40405)->[64]]
                                        ER = R [ N ] JR = R [ U ] sC = 32355228121818 kR = JR ( FR , yR ) HR = ER [ kR ] JR = R [ N ] yR , mR = "\\x17\\xDC\\x8F\\xD7\\xC1\\xB0$\\x97"
                                        --[[P(40694)->[353]]
                                        , 10332878443211 kR = R [ U ] FR = kR ( yR , mR ) ER = JR [ FR ] JR = 12 FR = R [ N ] yR = R [ U ] YC = "\\xFBE>:\\xA9vKy\\x91\\x07k\\xCE\\x04\\xFB"
                                        --[[P(40625)->[284]]
                                        mR = yR ( wC , PC ) kR = FR [ mR ] yR = R [ N ] PC = "\\xFC\\x86\\xB1\\x8F\\xA39\\x87\\xE3\\x06\\xCC"
                                        --[[P(40408)->[67]]
                                        mR = R [ U ] wC = mR ( PC , WC ) FR = yR [ wC ] mR = R [ y ] PC = R [ N ] WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] bC = "Lw\\xF6\\x91\\x9ASj!7\\xF6K%\\xFA\\xE7"
                                        --[[P(40909)->[568]]
                                        yR = mR [ wC ] XC = 1729750287141 wC = R [ N ] PC = R [ U ] WC = PC ( bC , XC ) bC = "Enum"
                                        --[[P(41057)->[716]]
                                        mR = wC [ WC ] WC = w [ bC ] XC = R [ N ] nC = R [ U ] MC = nC ( YC , gC ) bC = XC [ MC ] PC = WC [ bC ] YC = 34708225949474 bC = R [ N ] XC = R [ U ] MC = "\\xE3\\xC1\\xF2\\x90|"
                                        --[[P(40899)->[558]]
                                        nC = XC ( MC , YC ) WC = bC [ nC ] wC = PC [ WC ] WC = R [ N ] MC , nC = 24907337002318 , "\\xBD\\xB6\\x10\\x84\\xAB\\x12"
                                        --[[P(41024)->[683]]
                                        bC = R [ U ] XC = bC ( nC , MC ) PC = WC [ XC ] WC = 3 jR = { [ CR ] = DR , [ KR ] = GR , [ dR ] = xR , [ rR ] = HR , [ ER ] = JR , [ kR ] = nR , [ FR ] = yR ;
                                        [ mR ] = wC ;
                                        [ PC ] = WC } eR = gR ( tR , pR , jR ) ER = 3304499004930 tR = f ( ) R [ tR ] = eR GR , rR = 7419783105919 , "\\x17\nT}"
                                        --[[P(40683)->[342]]
                                        eR = R [ PR ] CR = R [ N ] KR = R [ U ] dR = "\\xBB\\x87\\x90[o"
                                        --[[P(40938)->[597]]
                                        DR = KR ( dR , GR ) jR = CR [ DR ] DR = R [ N ] yR , xR , HR = "F\\xF6\""
                                        --[[P(40523)->[182]]
                                        , 16673662033492 , 30440857679711 dR = R [ U ] XC = 1879629923179 GR = dR ( rR , xR ) xR = "\\xF0\\x11\\xEA\\xE55\\xD5J2\\xEF$v\\xE0\\xC9"
                                        --[[P(40948)->[607]]
                                        KR = DR [ GR ] dR = R [ N ] GR = R [ U ] rR = GR ( xR , HR ) DR = dR [ rR ] GR = R [ N ] FR , HR , bC = 3502931330655 , "\\x17d\\xAF\\x8A/\\xCC \\x8A"
                                        --[[P(40448)->[107]]
                                        , "\\xC5\\xC0\\xA6Sy\\xC2"
                                        --[[P(40914)->[573]]
                                        rR = R [ U ] xR = rR ( HR , ER ) kR = "L\\xF8k"
                                        --[[P(40814)->[473]]
                                        dR = GR [ xR ] mR , xR = 10617345250128 , "UDim2"
                                        --[[P(40720)->[379]]
                                        rR = w [ xR ] wC = "\\xD7/\\xB3\\xD5\\x92\\xF0\\xEAc"
                                        --[[P(41053)->[712]]
                                        HR = R [ N ] ER = R [ U ] JR = ER ( kR , FR ) ER , PC = 1 , 28467510391752 xR = HR [ JR ] GR = rR [ xR ] HR , kR , xR , JR = 24 , 13471952967809 , 0 , - 30 rR = GR ( xR , HR , ER , JR ) JR = "\\xE0\\x11:a"
                                        --[[P(40975)->[634]]
                                        xR = R [ N ] HR = R [ U ] ER = HR ( JR , kR ) RC = "(v\\xD6q"
                                        --[[P(41088)->[747]]
                                        GR = xR [ ER ] ER = "UDim2"
                                        --[[P(40720)->[379]]
                                        HR = w [ ER ] JR = R [ N ] kR = R [ U ] FR = kR ( yR , mR ) ER = JR [ FR ] xR = HR [ ER ] JR , FR , ER , kR , yR = - 48 , 5 , 1 , 0 , 23120351390222 HR = xR ( ER , JR , kR , FR ) ER = R [ N ] FR = "]\\x9D\\xA3\\x0E\\x13_\\xD0\\x94\\xAC\\xF9\\xAB\\xFA\\x9D\\xC7\\xCB\\x04"
                                        --[[P(40874)->[533]]
                                        JR = R [ U ] kR = JR ( FR , yR ) xR = ER [ kR ] JR = R [ y ] FR = R [ N ] yR = R [ U ] mR = yR ( wC , PC ) kR = FR [ mR ] ER = JR [ kR ] PC , wC , mR = "\\xE0\\xCA\\xB6\\x87\\xB6\\xE6\\xE9zq\\x19\\x14\\xA4\\xB4T\\xD3\\xE6"
                                        --[[P(40708)->[367]]
                                        , 4633857263725 , "\\x18U%\\xF5\\xDDqZ\\x86\\xB9v\\xC1@\\xD0@_"
                                        --[[P(40398)->[57]]
                                        kR = R [ N ] FR = R [ U ] WC = 1812286702411 yR = FR ( mR , wC ) JR = kR [ yR ] yR = R [ N ] mR = R [ U ] kR = 0 wC = mR ( PC , WC ) FR = yR [ wC ] yR = 9187421 < - 16736153 wC = R [ N ] PC = R [ U ] WC = PC ( bC , XC ) mR = wC [ WC ] wC = 3 CR = { [ KR ] = DR ;
                                        [ dR ] = rR , [ GR ] = HR ;
                                        [ xR ] = ER ;
                                        [ JR ] = kR ;
                                        [ FR ] = yR , [ mR ] = wC } yR = 4190855628703 KR = R [ qR ] bC = 12733816805161 pR = eR ( jR , CR , KR ) eR = f ( ) PC , KR = 20936293721621 , 5 R [ eR ] = pR pR = R [ MR ] ER , rR = 24350275054666 , 16104436276555 CR = R [ eR ] xR , mR = "gjQ\\x86"
                                        --[[P(40919)->[578]]
                                        , "X5\\xFC\\xDF\\xAC\\xE7"
                                        --[[P(40992)->[651]]
                                        jR = pR ( CR , KR ) pR = R [ PR ] GR , HR = "\\xC8\\x9C\\x02k\\xDA"
                                        --[[P(40784)->[443]]
                                        , 27474362724857 KR = R [ N ] DR = R [ U ] JR = 15571203988562 dR = DR ( GR , rR ) CR = KR [ dR ] dR = R [ N ] GR = R [ U ] WC = ")7\\xEE\\x14J\\xF2"
                                        --[[P(40421)->[80]]
                                        rR = GR ( xR , HR ) DR = dR [ rR ] GR = R [ N ] rR = R [ U ] HR = "\\x88~\\xF4\\xF1K\\x169r$\\xFD\\xDD\\xC5"
                                        --[[P(41081)->[740]]
                                        xR = rR ( HR , ER ) dR = GR [ xR ] rR = R [ N ] xR = R [ U ] FR , ER = "\\x085\\x19aF\\xFB\\x7F\\x05("
                                        --[[P(40693)->[352]]
                                        , "\\x99j\\x0B\\xB9"
                                        --[[P(40362)->[21]]
                                        HR = xR ( ER , JR ) GR = rR [ HR ] HR = "UDim2"
                                        --[[P(40720)->[379]]
                                        xR = w [ HR ] ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) FR , XC = 20745997346236 , 2466079818876 HR = ER [ kR ] ER , fC , kR = 1 , "a^\\x0C\\xC3\\x8C\\x82"
                                        --[[P(41066)->[725]]
                                        , "u\\xBF\\xA4\\xE8\\x9C\\xAF\\xEE\\x1E\\xE6C\\x19\\xC7\\xBF\\x0E}M"
                                        --[[P(40552)->[211]]
                                        rR = xR [ HR ] HR = 0 xR = rR ( HR , ER ) HR = R [ N ] ER = R [ U ] wC = 20358903768328 JR = ER ( kR , FR ) rR = HR [ JR ] ER = R [ y ] kR = R [ N ] FR = R [ U ] yR = FR ( mR , wC ) JR = kR [ yR ] yR , mR = "\\x9C\\xC0\\xEDK\\xEDW\\x16\\x06\\xB80\\xC7\\x10S\\x9B\\xD3"
                                        --[[P(40602)->[261]]
                                        , 18644171301353 HR = ER [ JR ] JR = R [ N ] kR = R [ U ] FR = kR ( yR , mR ) ER = JR [ FR ] wC = "\\xB1\\xA2q\\x15\\xEF\\x15eJY\\xD2\\x80\\xDA\n\\x8B\\x8Cu"
                                        --[[P(41077)->[736]]
                                        FR = R [ N ] JR = 0 yR = R [ U ] mR = yR ( wC , PC ) gC = 14115535608237 kR = FR [ mR ] mR = R [ N ] YC , FR = 25313811836427 , 11351942 <= 15208673 wC = R [ U ] PC = wC ( WC , bC ) yR = mR [ PC ] mR = 3 KR = { [ DR ] = dR ;
                                        [ GR ] = xR , [ rR ] = HR ;
                                        [ ER ] = JR , [ kR ] = FR , [ yR ] = mR } DR = R [ eR ] wC = "\\xBC9\\xAA6\\x086\\xC5w<"
                                        --[[P(40487)->[146]]
                                        jR = pR ( CR , KR , DR ) MC , rR = 3477532608083 , "\\xB2]\\x94:\\xF2"
                                        --[[P(40848)->[507]]
                                        pR = f ( ) ER = 31269172164832 R [ pR ] = jR jR = R [ MR ] kR , DR = 5975019490014 , 5 KR = R [ pR ] HR , mR , xR = "Q:\\xBDo"
                                        --[[P(40394)->[53]]
                                        , 21452936046341 , 10706092626809 CR = jR ( KR , DR ) jR = R [ PR ] DR = R [ N ] JR = 16768331832960 dR = R [ U ] GR = dR ( rR , xR ) KR = DR [ GR ] GR = R [ N ] rR = R [ U ] xR = rR ( HR , ER ) ER = "(\\xD7&\\xBE\"\\xB3r2\\xC3o3z:"
                                        --[[P(41071)->[730]]
                                        dR = GR [ xR ] rR = R [ N ] xR = R [ U ] HR = xR ( ER , JR ) GR = rR [ HR ] JR = "\\x0Ej\\xA5\\xD3D\\xBE\\x9D]"
                                        --[[P(40439)->[98]]
                                        xR = R [ N ] HR = R [ U ] nC = "cm\\xF3:\\x07H"
                                        --[[P(40673)->[332]]
                                        ER = HR ( JR , kR ) rR = xR [ ER ] ER = "UDim2"
                                        --[[P(40720)->[379]]
                                        HR = w [ ER ] WC = "\\xF3F>"
                                        --[[P(40777)->[436]]
                                        JR = R [ N ] kR = R [ U ] yR = "\\xFB\\xC3\\x0B\\xE9\\x95\\xC7\\xC6y\\x93"
                                        --[[P(40976)->[635]]
                                        FR = kR ( yR , mR ) bC = 8221047033588 ER = JR [ FR ] yR = 18498082136485 xR = HR [ ER ] ER , JR , FR = - 0.5 , 0 , "vp\\x10U"
                                        --[[P(40665)->[324]]
                                        HR = xR ( ER , JR ) ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) xR = ER [ kR ] kR = "UDim2"
                                        --[[P(40720)->[379]]
                                        JR = w [ kR ] PC = 21776500877212 FR = R [ N ] yR = R [ U ] mR = yR ( wC , PC ) kR = FR [ mR ] ER = JR [ kR ] FR , wC , mR , kR = 1 , 20976789890600 , "\\xEA\\xD1\\x1F'K2\\xF1\\xEEb\\xD3\\xBD\\x84\\xAF\\x9Dyd"
                                        --[[P(40569)->[228]]
                                        , 0.5 JR = ER ( kR , FR ) kR = R [ N ] FR = R [ U ] yR = FR ( mR , wC ) ER = kR [ yR ] yR = "Color3"
                                        --[[P(40825)->[484]]
                                        FR = w [ yR ] mR = R [ N ] wC = R [ U ] PC = wC ( WC , bC ) yR = mR [ PC ] mR = 1 kR = FR [ yR ] PC , yR , wC , bC = "{\\xFE\\xFA\\xB4F\\xF19\\x0B\\x05.\\xD7~\\xE7\\xE4X\\xDE9\\x00\\xBFZ:\\x88"
                                        --[[P(40554)->[213]]
                                        , 1 , 1 , "\\x11\\x8C\\x07w\\x02\\x98@X\\x1B\\x8E\\x88\\x07e|\\xC0"
                                        --[[P(40368)->[27]]
                                        FR = kR ( yR , mR , wC ) yR = R [ N ] mR = R [ U ] WC = 29196283983131 wC = mR ( PC , WC ) kR = yR [ wC ] yR = 0.5 wC = R [ N ] PC = R [ U ] WC = PC ( bC , XC ) mR = wC [ WC ] WC = R [ N ] wC = 0 bC = R [ U ] XC = bC ( nC , MC ) PC = WC [ XC ] WC , MC , UC = 4 , "}\\xF5\\xDBs\\xE7\\xAE"
                                        --[[P(40539)->[198]]
                                        , 22857842731412 DR = { [ dR ] = GR ;
                                        [ rR ] = HR ;
                                        [ xR ] = JR ;
                                        [ ER ] = FR , [ kR ] = yR ;
                                        [ mR ] = wC ;
                                        [ PC ] = WC } dR = R [ pR ] wC = "G\\xA8*"
                                        --[[P(40517)->[176]]
                                        CR = jR ( KR , DR , dR ) jR = R [ PR ] xR = "m\\x89[\\xFB\\x94\\xD5d\\xE4\\xC6\\xCE"
                                        --[[P(40822)->[481]]
                                        dR = R [ N ] HR , ER = 32500783004446 , "\\x97\\xE9\\x92\\xDCp\\xB9~T:\\x82\\x9C\\xA0"
                                        --[[P(40635)->[294]]
                                        GR = R [ U ] JR , yR = 5969011165915 , 16949485575892 rR = GR ( xR , HR ) DR = dR [ rR ] rR = R [ N ] xR = R [ U ] HR = xR ( ER , JR ) GR = rR [ HR ] FR , HR , bC = "\\x7FfZ"
                                        --[[P(40897)->[556]]
                                        , "NumberSequence"
                                        --[[P(40652)->[311]]
                                        , 10232623878812 xR = w [ HR ] ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) HR = ER [ kR ] kR = "NumberSequenceKeypoint"
                                        --[[P(41015)->[674]]
                                        rR = xR [ HR ] PC = 7933756149358 JR = w [ kR ] FR = R [ N ] yR = R [ U ] mR = yR ( wC , PC ) kR = FR [ mR ] ER = JR [ kR ] kR , FR = 0 , 1 JR = ER ( kR , FR ) FR = "NumberSequenceKeypoint"
                                        --[[P(41015)->[674]]
                                        kR = w [ FR ] yR = R [ N ] WC = 29089362556137 mR = R [ U ] PC = "\\x14\\xAF\\x87"
                                        --[[P(40792)->[451]]
                                        wC = mR ( PC , WC ) WC = "\\x04\\xE4f"
                                        --[[P(40346)->[5]]
                                        FR = yR [ wC ] ER = kR [ FR ] FR , yR = 0.5 , 0 kR = ER ( FR , yR ) yR = "NumberSequenceKeypoint"
                                        --[[P(41015)->[674]]
                                        FR = w [ yR ] mR = R [ N ] wC = R [ U ] PC = wC ( WC , bC ) bC = 21548387346226 yR = mR [ PC ] ER = FR [ yR ] yR , wC , mR = 1 , 28672049706023 , 1 FR = { ER ( yR , mR ) } HR = { JR ;
                                        kR , b ( FR ) } xR = rR ( HR ) mR , JR , dR = 30901649258549 , 12567613429468 , { [ GR ] = xR } GR , yR , ER = "TweenInfo"
                                        --[[P(40354)->[13]]
                                        , "\"\\xB0F\\x8E\\xDE\\xF6\\x9D2#u\\xD1"
                                        --[[P(40835)->[494]]
                                        , "\\x8D\\x92U"
                                        --[[P(40401)->[60]]
                                        KR = jR ( DR , dR , CR ) jR = R [ t ] dR = w [ GR ] rR = R [ N ] xR = R [ U ] HR = xR ( ER , JR ) ER = "Enum"
                                        --[[P(41057)->[716]]
                                        GR = rR [ HR ] DR = dR [ GR ] HR = w [ ER ] JR = R [ N ] GR = .9 kR = R [ U ] FR = kR ( yR , mR ) ER = JR [ FR ] xR = HR [ ER ] WC , FR , yR = "\\xCA\\xEF\\x10~,M\\x8A\\x19\\xA5"
                                        --[[P(40939)->[598]]
                                        , "\\xA2\\x03\\xEF\\xEA"
                                        --[[P(40851)->[510]]
                                        , 12112253801992 ER = R [ N ] PC = 7776075714085 JR = R [ U ] kR = JR ( FR , yR ) HR = ER [ kR ] rR = xR [ HR ] JR = "Enum"
                                        --[[P(41057)->[716]]
                                        ER = w [ JR ] kR = R [ N ] mR = "Q\\xD4\\xB7&IO(\\xD4\\xE1\\xD3!\\x92\\x9BT("
                                        --[[P(40778)->[437]]
                                        FR = R [ U ] yR = FR ( mR , wC ) JR = kR [ yR ] HR = ER [ JR ] JR = R [ N ] kR = R [ U ] KR , yR , mR = "Create"
                                        --[[P(40492)->[151]]
                                        , "s\\xB7~\\x83\\xA8"
                                        --[[P(40596)->[255]]
                                        , 23191639878191 FR = kR ( yR , mR ) ER = JR [ FR ] xR = HR [ ER ] HR = - 1 dR = DR ( GR , rR , xR , HR ) rR = R [ N ] JR = 1278156751443 xR = R [ U ] ER = "\\xD7\\x9A\\xAF\\x7F\\x93`C3"
                                        --[[P(40374)->[33]]
                                        HR = xR ( ER , JR ) GR = rR [ HR ] yR , HR = 9058881589370 , "UDim2"
                                        --[[P(40720)->[379]]
                                        xR = w [ HR ] ER = R [ N ] KR = jR [ KR ] JR = R [ U ] FR = "\\xCB\\x1D\\xC96\\xC1\\xC8j.W"
                                        --[[P(40820)->[479]]
                                        kR = JR ( FR , yR ) HR = ER [ kR ] rR = xR [ HR ] ER , nC , HR = 0 , 23735561906988 , 1 xR = rR ( HR , ER ) XC , DR = "\\xBBm\\xD2\\xDBC\\x1E\\xBB\\xCE'F"
                                        --[[P(40434)->[93]]
                                        , { [ GR ] = xR } KR = KR ( jR , CR , dR , DR ) jR = f ( ) JR , FR = "\\xFB\\xD17B"
                                        --[[P(40947)->[606]]
                                        , 29417785357698 R [ jR ] = KR KR = R [ jR ] ER , DR = 27382495523278 , "Play"
                                        --[[P(40349)->[8]]
                                        DR , HR , yR , kR = KR [ DR ] , "`\\x98\\xE3]\\x9C"
                                        --[[P(40921)->[580]]
                                        , 10842294719416 , 22024154097679 DR = DR ( KR ) KR = R [ PR ] GR = R [ N ] rR = R [ U ] xR = rR ( HR , ER ) dR = GR [ xR ] xR = R [ N ] HR = R [ U ] wC = "\\xE7K\t"
                                        --[[P(40351)->[10]]
                                        ER = HR ( JR , kR ) rR = xR [ ER ] kR = "\\xDD\\xA4\\xD6\\x80\\xDA{\\xC2\\xA4\\x8F\\xADuj"
                                        --[[P(40818)->[477]]
                                        HR = R [ N ] ER = R [ U ] JR = ER ( kR , FR ) FR = "\\x07s\\xD2 j@\\x1A\\x1Fh\\xA9B"
                                        --[[P(41090)->[749]]
                                        xR = HR [ JR ] ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) HR = ER [ kR ] kR = "Vector2"
                                        --[[P(40861)->[520]]
                                        JR = w [ kR ] FR = R [ N ] yR = R [ U ] mR = yR ( wC , PC ) kR = FR [ mR ] ER = JR [ kR ] kR , mR , FR = 0.5 , "\\x1Fh,g\\xBA\\xC1\\xA1\\xE3"
                                        --[[P(40435)->[94]]
                                        , 0.5 JR = ER ( kR , FR ) wC = 6967230057644 kR = R [ N ] FR = R [ U ] yR = FR ( mR , wC ) ER = kR [ yR ] yR = "UDim2"
                                        --[[P(40720)->[379]]
                                        FR = w [ yR ] mR = R [ N ] wC = R [ U ] PC = wC ( WC , bC ) yR = mR [ PC ] kR = FR [ yR ] mR , yR , PC , WC = 0.5 , 0 , "6\\xF7)\\xF2"
                                        --[[P(40584)->[243]]
                                        , 3860875790085 FR = kR ( yR , mR ) yR = R [ N ] mR = R [ U ] wC = mR ( PC , WC ) kR = yR [ wC ] wC = "UDim2"
                                        --[[P(40720)->[379]]
                                        mR = w [ wC ] PC = R [ N ] WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] yR = mR [ wC ] XC , PC , wC = 27523406836240 , 11 , 11 mR = yR ( wC , PC ) bC = "\\x8C\\xD9\\xD0\\x1Ei\\xD3`\\xD4E\\x13\\xA7&\\xB9\\x84\\x04\\xF5"
                                        --[[P(40452)->[111]]
                                        wC = R [ N ] PC = R [ U ] WC = PC ( bC , XC ) yR = wC [ WC ] PC = R [ y ] bC = R [ N ] XC = R [ U ] nC = XC ( MC , YC ) WC = bC [ nC ] wC = PC [ WC ] WC = R [ N ] nC , YC = "\\xDA\\x91\\x1A\\xC5\\x0E;\\xC8\\xAE\\xE8@\\x0F\\xA0\\x87\\x1D\\x9F"
                                        --[[P(40578)->[237]]
                                        , "m\\x0Ei\\xE4\\xCC\\x16"
                                        --[[P(40761)->[420]]
                                        bC = R [ U ] MC = 7049271938258 XC = bC ( nC , MC ) PC = WC [ XC ] WC = 0 XC = R [ N ] nC = R [ U ] MC = nC ( YC , gC ) bC = XC [ MC ] XC = 5 GR = { [ rR ] = xR , [ HR ] = JR ;
                                        [ ER ] = FR , [ kR ] = mR , [ yR ] = wC ;
                                        [ PC ] = WC ;
                                        [ bC ] = XC } rR = R [ eR ] PC , FR , bC , ER , JR = "\\x90\\xA1\\xD7"
                                        --[[P(40875)->[534]]
                                        , 15270318971846 , "\\xF1q\\x04\\xBE\\\\xD1W\\xA2\\xD2"
                                        --[[P(40727)->[386]]
                                        , "X\\xBF\\x87v\\x93\\x05\\xAD\\xB6\\xE5\\x11"
                                        --[[P(40699)->[358]]
                                        , 11106229621811 DR = KR ( dR , GR , rR ) KR = f ( ) R [ KR ] = DR DR = R [ MR ] mR , rR = 13572309440688 , 6 GR = R [ KR ] dR = DR ( GR , rR ) DR = R [ PR ] rR = R [ N ] xR = R [ U ] HR = xR ( ER , JR ) kR = "2VT\\x95"
                                        --[[P(40668)->[327]]
                                        GR = rR [ HR ] HR = R [ N ] yR = 8127447502536 ER = R [ U ] JR = ER ( kR , FR ) xR = HR [ JR ] WC , FR = 18747851579930 , "G\\\\xFF\\xDCL\\x04\\x91e\\x97@\\xEB["
                                        --[[P(40671)->[330]]
                                        ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) HR = ER [ kR ] yR = "<\\xE2,\\xEA\\xB4\\xFAND\\x88\\xF3T"
                                        --[[P(40562)->[221]]
                                        JR = R [ N ] kR = R [ U ] FR = kR ( yR , mR ) ER = JR [ FR ] FR , nC = "Vector2"
                                        --[[P(40861)->[520]]
                                        , "~J\\x95%\\xA13\\x0B\\xAC\\x0F{"
                                        --[[P(40385)->[44]]
                                        kR = w [ FR ] YC = 10745588929419 yR = R [ N ] mR = R [ U ] wC = mR ( PC , WC ) FR = yR [ wC ] yR = 0.5 JR = kR [ FR ] FR , wC = 0.5 , "%\\xCF\\xF9\\xDB-\\xCE\"\\x0D"
                                        --[[P(40902)->[561]]
                                        kR = JR ( FR , yR ) PC = 5443858401766 FR = R [ N ] yR = R [ U ] mR = yR ( wC , PC ) JR = FR [ mR ] mR = "UDim2"
                                        --[[P(40720)->[379]]
                                        yR = w [ mR ] wC = R [ N ] XC = 19541320606603 PC = R [ U ] WC = PC ( bC , XC ) mR = wC [ WC ] FR = yR [ mR ] MC , mR , wC = 13377614551125 , 0.5 , 0.5 yR = FR ( mR , wC ) mR = R [ N ] WC , bC = "zDG\\x94"
                                        --[[P(40459)->[118]]
                                        , 512965050606 wC = R [ U ] PC = wC ( WC , bC ) FR = mR [ PC ] PC = "UDim2"
                                        --[[P(40720)->[379]]
                                        wC = w [ PC ] WC = R [ N ] bC = R [ U ] XC = bC ( nC , MC ) PC = WC [ XC ] WC , XC = 40 , ".\\x89\"\\xAD1\\x0D\\xFF\\x11\\xAD\\xB5O8\\xA3l\\xC9\\xDBm\\xF4\\xA9U\\x96\\x84"
                                        --[[P(40555)->[214]]
                                        mR = wC [ PC ] nC , PC = 13446311073909 , 40 wC = mR ( PC , WC ) PC = R [ N ] WC = R [ U ] bC = WC ( XC , nC ) MC = "Pj\\xBB\\xAA\\x8D"
                                        --[[P(41013)->[672]]
                                        mR = PC [ bC ] bC = R [ N ] PC = 1 XC = R [ U ] nC = XC ( MC , YC ) WC = bC [ nC ] XC = R [ F ] MC = R [ N ] YC = R [ U ] gC = YC ( RC , hC ) nC = MC [ gC ] RC = 9163588227243 bC = XC [ nC ] gC = "\\x9A\\x1C\\xEB\\x0D\\xDA{\\xD48.\\xCA\\x90"
                                        --[[P(40567)->[226]]
                                        nC = R [ N ] MC = R [ U ] YC = MC ( gC , RC ) XC = nC [ YC ] MC = R [ y ] gC = R [ N ] RC = R [ U ] hC = RC ( fC , UC ) YC = gC [ hC ] nC = MC [ YC ] YC = R [ N ] hC , fC = "\\x0FR\\x0C=\\xF1\\xE5\\x89W\\xB5<\\x0D\\xBC\\xF2\\x87p\\x92V"
                                        --[[P(40771)->[430]]
                                        , 19432905581401 gC = R [ U ] RC = gC ( hC , fC ) MC = YC [ RC ] UC = "\\x10 \\x00bL\\xCC"
                                        --[[P(40644)->[303]]
                                        RC = R [ N ] hC = R [ U ] fC = hC ( UC , sC ) YC = .55 gC = RC [ fC ] RC = 4 rR = { [ xR ] = HR , [ ER ] = kR ;
                                        [ JR ] = yR ;
                                        [ FR ] = wC ;
                                        [ mR ] = PC ;
                                        [ WC ] = bC , [ XC ] = nC , [ MC ] = YC , [ gC ] = RC } xR = R [ KR ] JR = 24135999499239 dR = DR ( GR , rR , xR ) dR = f ( ) ER , DR = "\\x96\\xFA\\x8A+\\xC0\\xD5\\x18.\\xC3As*o"
                                        --[[P(40437)->[96]]
                                        , 263390 < 10220336 R [ dR ] = DR rR = R [ N ] xR = R [ U ] HR = xR ( ER , JR ) GR = rR [ HR ] rR = a ( 13746815 , { dR , eR , N , U ;
                                        pR , KR ;
                                        tR } ) DR = G [ GR ] FR , GR = 12742172743469 , "Connect"
                                        --[[P(40953)->[612]]
                                        GR , XC = DR [ GR ] , "+>\\xAB?5\\xA0\\xE8C\\x1CWU\\xE7\\x98A[\\x12\\xB9\\x18\\xEDI\\xB6("
                                        --[[P(40750)->[409]]
                                        GR = GR ( DR , rR ) xR = "Random"
                                        --[[P(41029)->[688]]
                                        DR = f ( ) R [ DR ] = GR rR = w [ xR ] HR = R [ N ] ER = R [ U ] kR , yR = "\\xAF:\\x92"
                                        --[[P(40952)->[611]]
                                        , 25292892237313 JR = ER ( kR , FR ) xR = HR [ JR ] GR = rR [ xR ] rR = GR ( ) GR = f ( ) HR = "task"
                                        --[[P(40721)->[380]]
                                        R [ GR ] = rR xR = w [ HR ] FR = "\\xC4\\x8F\\x1Bc\\xA4"
                                        --[[P(40681)->[340]]
                                        ER = R [ N ] JR = R [ U ] kR = JR ( FR , yR ) HR = ER [ kR ] rR = xR [ HR ] HR = c ( 4268668 , { dR ;
                                        qR , N , U , GR , PR ;
                                        y , MR , YR } ) xR = rR ( HR ) rR = f ( ) xR = q ( 8579639 , { dR , YR , AR ;
                                        N ;
                                        U } ) R [ rR ] = xR ER = a ( 1636512 , { dR ;
                                        DR , QR ;
                                        jR ;
                                        YR , qR , N ;
                                        U , sR , cR , fR ;
                                        NR ;
                                        hR } ) HR = i ( 2518240 , { dR ;
                                        YR ;
                                        pR ;
                                        N ;
                                        U } ) xR = f ( ) R [ xR ] = HR HR = f ( ) yR = .45 JR = O ( 2027256 , { dR ;
                                        DR , rR ;
                                        N , U ;
                                        tR , y , pR , KR , YR ;
                                        HR } ) nC = 30716707665887 R [ HR ] = ER ER = f ( ) R [ ER ] = JR JR = R [ YR ] FR = R [ fR ] PC = R [ N ] WC = R [ U ] bC = WC ( XC , nC ) wC = PC [ bC ] PC = .48 mR = { [ wC ] = PC } kR = JR ( FR , yR , mR ) JR = R [ NR ] W = JR and 1967474 or 1307566
                                    elseif W < 5480508 then
                                        s = 201 U = R [ M [ 3 ] ] h = U * s s , U = 1 , 257 g = h % U R [ M [ 3 ] ] = g U = R [ M [ 3 ] ] h = U ~= s W = h and 14586779 or 5464531
                                    else
                                        A = 1 g = S == A W = g and 13578987 or - 12634313
                                    end
                                else
                                    if W < 5612595 then
                                        S , U = 30629398525878 , "math"
                                        --[[P(40389)->[48]]
                                        W = R [ M [ 1 ] ] Z , u = "X\\xCFSW-"
                                        --[[P(40433)->[92]]
                                        , "\\xF5"
                                        --[[P(40742)->[401]]
                                        g = W ( ) h = g g = w [ U ] s = R [ M [ 2 ] ] N = R [ M [ 3 ] ] A = "\\xDE\\x93y"
                                        --[[P(40377)->[36]]
                                        T = N ( Z , S ) N = "math"
                                        --[[P(40389)->[48]]
                                        U = s [ T ] W = g [ U ] s = w [ N ] T = R [ M [ 2 ] ] Z = R [ M [ 3 ] ] o = 2544843392161 S = Z ( A , o ) N = T [ S ] U = s [ N ] S = R [ M [ 2 ] ] v = 146423595076 A = R [ M [ 3 ] ] o = A ( u , v ) Z = S [ o ] T = h [ Z ] Z = 365 N = T / Z e , v = 32477607639827 , "\\xA8"
                                        --[[P(40832)->[491]]
                                        A = R [ M [ 2 ] ] o = R [ M [ 3 ] ] u = o ( v , e ) S = A [ u ] Z = h [ S ] S = 190 T = Z / S s = U ( N , T ) N , U = 1 , .78 g = { W ( s , U , N ) } g , W = { b ( g ) } , w [ "wmO73hLnGK6yQ"
                                        --[[P(40686)->[345]]
                                        ]
                                    elseif W < 5714439 then
                                        W = R [ M [ 1 ] ] g = "Cancel"
                                        --[[P(40801)->[460]]
                                        g = W [ g ] g = g ( W ) W , g = w [ "L61x83ByN3ZXZ"
                                        --[[P(40857)->[516]]
                                        ] , { }
                                    elseif W < - 6629130 then
                                        W = 13477644
                                    else
                                        h = "error"
                                        --[[P(40380)->[39]]
                                        W = w [ h ] s = 0 U = R [ M [ 8 ] ] h = W ( U , s ) W = 14181328
                                    end
                                end
                            else
                                if 4800540 > W then
                                    if W < 4757301 then
                                        g = R [ M [ 16 ] ] v , e = "\\xDB\\x88\\x90\\xDF\\xF1\\x14\\xB5e\\x8DU\\xBA\\xEF\\xDC:\\x80\\xEC\\x06"
                                        --[[P(41065)->[724]]
                                        , 20981866358314 A = R [ M [ 4 ] ] o = R [ M [ 5 ] ] u = o ( v , e ) S = A [ u ] Z = g ( S ) S , A , e = .9 , .35 , 2070969500612 g = R [ M [ 17 ] ] Z = g ( S , A ) S = "task"
                                        --[[P(40721)->[380]]
                                        Z = w [ S ] v = "\\xD9\\xE6T1"
                                        --[[P(40620)->[279]]
                                        A = R [ M [ 4 ] ] o = R [ M [ 5 ] ] u = o ( v , e ) S = A [ u ] g = Z [ S ] e , S = 19733920998373 , .38 Z = g ( S ) g = R [ M [ 16 ] ] A = R [ M [ 4 ] ] o = R [ M [ 5 ] ] v = "\\x83\\x92\\x9B\\xB8-PQ\\x91\\x8C\\x89\\xBB\\x89\\x93L\\x97*0"
                                        --[[P(40574)->[233]]
                                        u = o ( v , e ) v = "H\\xB7\\xB6<"
                                        --[[P(41022)->[681]]
                                        S = A [ u ] A = 0.25 Z = g ( S ) S = 1 g = R [ M [ 17 ] ] Z = g ( S , A ) S = "task"
                                        --[[P(40721)->[380]]
                                        Z = w [ S ] A = R [ M [ 4 ] ] e = 19830525649938 o = R [ M [ 5 ] ] u = o ( v , e ) S = A [ u ] g = Z [ S ] S = .42 Z = g ( S ) Z = "pcall"
                                        --[[P(40547)->[206]]
                                        g = w [ Z ] A = { g ( N ) } Z = A [ 1 ] S , g = A [ 2 ] , not Z W = g and 9799928 or 3005442
                                    elseif W < - 5656508 then
                                        g , W = { } , w [ "pBznEIX98ywr44"
                                        --[[P(40983)->[642]]
                                        ]
                                    elseif - 5302618 > W then
                                        W = 6036205
                                    else
                                        W = R [ M [ 1 ] ] g = "Destroy"
                                        --[[P(40466)->[125]]
                                        g = W [ g ] g = g ( W ) g , W = { } , w [ "aum51oFTCDlEl"
                                        --[[P(40649)->[308]]
                                        ]
                                    end
                                else
                                    if 4833062 > W then
                                        C = R [ N ] H , E = "3\\xEE\\xD0"
                                        --[[P(40860)->[519]]
                                        , 21555347826485 r = R [ U ] G = r ( H , E ) W = w [ "jXeLc3kOH8DFQ"
                                        --[[P(40648)->[307]]
                                        ] t = C [ G ] g = { t }
                                    elseif 4865506 > W then
                                        Z = g ( S ) g , W = { } , A W = w [ "UN5YpdFYiOqBo"
                                        --[[P(40356)->[15]]
                                        ]
                                    elseif - 5967408 > W then
                                        T = R [ M [ 1 ] ] A , o = "?\\xEAq\\xB5\\xBF\\xF8"
                                        --[[P(40886)->[545]]
                                        , 22517252810997 Z = R [ M [ 2 ] ] S = Z ( A , o ) W = T [ S ] T = s N [ W ] = T W = 13438951
                                    else
                                        W , g = w [ "2d0IHEM4LmsM"
                                        --[[P(40685)->[344]]
                                        ] , { U }
                                    end
                                end
                            end
                        end
                    else
                        if W > 7228408 then
                            if 7852003 > W then
                                if 7656087 > W then
                                    if 7360506 > W then
                                        W = R [ M [ 10 ] ] U = R [ M [ 11 ] ] h [ W ] = U W = R [ M [ 12 ] ] U = { W ( h ) } g , W = { b ( U ) } , w [ "boGi3AfHUz7C"
                                        --[[P(40424)->[83]]
                                        ]
                                    elseif W < 7513613 then
                                        I = f ( ) v , e = nil , { } C = f ( ) R [ I ] = e t = z ( 6353707 , { I , S , T , Z } ) e = f ( ) R [ e ] = t J , x , d , H , o , t , r , v = nil , "__metatable"
                                        --[[P(40700)->[359]]
                                        , "setmetatable"
                                        --[[P(41070)->[729]]
                                        , "__index"
                                        --[[P(40819)->[478]]
                                        , nil , { } , { } , 22126428612671 R [ C ] = t t = w [ d ] E = R [ C ] G , s = { [ H ] = E , [ x ] = J } , nil d = t ( r , G ) R [ N ] = d t = z ( 7912786 , { C , I ;
                                        A , S ;
                                        T ;
                                        e } ) T = B ( T ) R [ U ] = t T = "getfenv"
                                        --[[P(40930)->[589]]
                                        A = B ( A ) S = B ( S ) C = B ( C ) s = w [ T ] u = nil e = B ( e ) r = "\\x9C\\xD84t\\xA0Io\\xDD}'pZo\\x95\\xC3=\\xD5\\xF5C&\\x16w\\xFA!\\xED\\x87{[n"
                                        --[[P(40550)->[209]]
                                        I = B ( I ) Z = B ( Z ) T = s ( ) s = f ( ) R [ s ] = T T = R [ s ] u , G = "\\xE2\\xF4\\xC7C\\xD1\\x1F\\xAE\\xF7\\x80\\xA4\\xC6B"
                                        --[[P(40713)->[372]]
                                        , 25237642063336 S = R [ N ] t = 22367117977775 A = R [ U ] o = A ( u , v ) Z = S [ o ] S = 5433330 <= 5824988 T [ Z ] = S T = 3 Z = f ( ) R [ Z ] = T S = f ( ) T = 9999 A = V ( 8934105 , { N ;
                                        U } ) R [ S ] = T T = f ( ) R [ T ] = A A = R [ s ] u = R [ N ] I = "\\x88s\\xD1\\x02\\xF6\\xB0\\xA9\\x1A\\xF1\\xE9\\x17"
                                        --[[P(40879)->[538]]
                                        v = R [ U ] e = v ( I , t ) o = u [ e ] u = R [ T ] e = R [ S ] v = u ( e ) A [ o ] = v A = R [ T ] u = R [ S ] o = A ( u ) A = f ( ) R [ A ] = o o = R [ T ] v = R [ S ] u = o ( v ) o = f ( ) R [ o ] = u v = "print"
                                        --[[P(40591)->[250]]
                                        u = w [ v ] I = R [ N ] t = R [ U ] C = t ( r , G ) e = I [ C ] v = u ( e ) e = "task"
                                        --[[P(40721)->[380]]
                                        v = w [ e ] r = "\\x8B\\xCA\\x92\\x8F7"
                                        --[[P(40588)->[247]]
                                        I = R [ N ] t = R [ U ] G = 4982196996368 C = t ( r , G ) r , G = "\\xC7F\\x11\\xC9\\x06\\xE0\""
                                        --[[P(40651)->[310]]
                                        , 5512655374855 e = I [ C ] u = v [ e ] e = c ( 16553135 , { s ;
                                        N ;
                                        U , Z ;
                                        T , S ;
                                        A ;
                                        o } ) v = u ( e ) v = "game"
                                        --[[P(40378)->[37]]
                                        u = w [ v ] I = R [ N ] t = R [ U ] C = t ( r , G ) v = "GetService"
                                        --[[P(40672)->[331]]
                                        v , r = u [ v ] , "\\xB6\\x11\\xFB\\xA4\\xE2\\x10\\xEE\\xD78\\x02D"
                                        --[[P(40949)->[608]]
                                        e = I [ C ] G = 14106976754089 v = v ( u , e ) I = R [ N ] t = R [ U ] C = t ( r , G ) e = I [ C ] u = v [ e ] e = not u W = e and 3083667 or 7032068
                                    elseif 7623670 > W then
                                        W = k W = 641977 R [ U ] = g
                                    else
                                        W = g and 8632295 or 16581772
                                    end
                                else
                                    if - 7873136 > W then
                                        A , o , U = 0 , 255 , s W = R [ M [ 1 ] ] S = W ( A , o ) W = 11617609 h [ U ] = S U = nil
                                    elseif 7710713 > W then
                                        S , N = not Z , N + T g = s >= N g = S and g S = s <= N S = Z and S g = S or g S = 10743589 W = g and S g = 12030801 W = W or g
                                    elseif 7770719 > W then
                                        W = bR R [ U ] = k WR = R [ E ] wR = 1 F = WR + wR y = J [ F ] m = u + y y = 256 bR = m % y u , W = bR , 641977 F = R [ H ] y = e + F F = 256 m = y % F e = m
                                    else
                                        N = n [ 4 ] W = R [ M [ 1 ] ] Z = R [ M [ 2 ] ] e , h = 12327202887276 , n [ 1 ] S = R [ M [ 3 ] ] o , U , u , s = "e\\xAC;#\\xDFa\\xC4\\xFD"
                                        --[[P(40482)->[141]]
                                        , n [ 2 ] , 31432747448621 , n [ 3 ] A = S ( o , u ) v = "\\xAF\\x90/\\x1A)"
                                        --[[P(40528)->[187]]
                                        T = Z [ A ] A = R [ M [ 2 ] ] o = R [ M [ 3 ] ] u = o ( v , e ) o = W S = A [ u ] A , W = U , U and 2963803 or 13224328
                                    end
                                end
                            else
                                if W < 8022068 then
                                    if W < 7942356 then
                                        h = n [ 1 ] W = R [ M [ 1 ] ] s , U = W , n [ 2 ] W = s [ U ] W = W and 4128390 or 3765067
                                    elseif 7978499 > W then
                                        x = "\\xD7\\x03[r/\\xA6\\x92\\xF4A"
                                        --[[P(40701)->[360]]
                                        G = R [ N ] H = R [ U ] J = 18047204221139 E = H ( x , J ) r = G [ E ] C = I [ r ] x = "\\xE7U{q\\xA5\\xDB\\xAA!"
                                        --[[P(41026)->[685]]
                                        G = R [ N ] H = R [ U ] J = 29523637089716 E = H ( x , J ) r = G [ E ] t = C ~= r W = t and - 4910513 or 3158278
                                    elseif 7992643 > W then
                                        U = R [ M [ 2 ] ] W = 12705080 s = R [ M [ 3 ] ] h = U == s g = h
                                    else
                                        A , e = "Enum"
                                        --[[P(41057)->[716]]
                                        , "A\\xB2\\xC4B_C\\x86\\x0D\\x92$\\xA5A"
                                        --[[P(41091)->[750]]
                                        S = w [ A ] I = 6598234704896 o = R [ M [ 1 ] ] u = R [ M [ 2 ] ] v = u ( e , I ) A = o [ v ] Z = S [ A ] v = "\\xC6=\\xA6\\xF6\\x1D"
                                        --[[P(40347)->[6]]
                                        A = R [ M [ 1 ] ] o = R [ M [ 2 ] ] e = 9719143485869 u = o ( v , e ) S = A [ u ] T = Z [ S ] g , W = T , 1551787
                                    end
                                else
                                    if W < 8046623 then
                                        g = R [ M [ 1 ] ] U = R [ M [ 2 ] ] s = R [ M [ 3 ] ] T , Z = "\\xD7s\\x97\\x97\\x16\\xC6&"
                                        --[[P(40536)->[195]]
                                        , 18215467393314 N = s ( T , Z ) h = U [ N ] W = g [ h ] W = W and 9370473 or 6547961
                                    elseif W < 8212907 then
                                        W , g = w [ "OF3gHFMNCwAD"
                                        --[[P(40609)->[268]]
                                        ] , { }
                                    else
                                        S , v = "type"
                                        --[[P(40581)->[240]]
                                        , "\\x18^<\\xC1G_\\x05\\x8E"
                                        --[[P(40773)->[432]]
                                        Z = w [ S ] S = Z ( N ) A = R [ M [ 4 ] ] e = 20853492245998 o = R [ M [ 5 ] ] u = o ( v , e ) Z = A [ u ] g = S ~= Z W = g and 5037771 or 4745177
                                    end
                                end
                            end
                        else
                            if W < 6494256 then
                                if W > - 6736475 then
                                    if W < 6228020 then
                                        W = A A = { W ( S ) } W , T , g = 15525964 , A [ 2 ] , A [ 1 ] S , Z = g , A [ 3 ]
                                    elseif W < 6368169 then
                                        h = R [ M [ 1 ] ] g = # h h = 0 W = g == h W = W and 1689225 or 10863621
                                    elseif 6416811 > W then
                                        h = "math"
                                        --[[P(40389)->[48]]
                                        g = w [ h ] U = R [ M [ 3 ] ] Z = 24553351539881 s = R [ M [ 4 ] ] T , o = "\\x00Q/\\xB2r"
                                        --[[P(41056)->[715]]
                                        , "F\\xF8#\\xAE"
                                        --[[P(40660)->[319]]
                                        N = s ( T , Z ) u = 10975781491702 h = U [ N ] W = g [ h ] N = R [ M [ 5 ] ] Z = R [ M [ 3 ] ] S = R [ M [ 4 ] ] A = S ( o , u ) o = 22725200439638 T = Z [ A ] A = "V"
                                        --[[P(41001)->[660]]
                                        s = N [ T ] T = R [ M [ 3 ] ] Z = R [ M [ 4 ] ] S = Z ( A , o ) N = T [ S ] U = s [ N ] N = R [ M [ 3 ] ] A , S = 211274154082 , "{\\x01\\x189\\xFF"
                                        --[[P(40413)->[72]]
                                        T = R [ M [ 4 ] ] Z = T ( S , A ) A , v , T = "\\xB1\\xD2b"
                                        --[[P(40913)->[572]]
                                        , "\\x16Z\\xCD\\xD8\\x95"
                                        --[[P(40762)->[421]]
                                        , "\\xFBia\\xE3\\xBE\\x9F\\xC5\\x1F"
                                        --[[P(40954)->[613]]
                                        s = N [ Z ] h = U [ s ] s , U , o = 1 , 0 , 29692430497282 g = W ( h , U , s ) h = g W = R [ M [ 6 ] ] Z = 18751857222172 U = R [ M [ 3 ] ] s = R [ M [ 4 ] ] N = s ( T , Z ) g = U [ N ] N = "UDim2"
                                        --[[P(40720)->[379]]
                                        s = w [ N ] T = R [ M [ 3 ] ] Z = R [ M [ 4 ] ] S = Z ( A , o ) N = T [ S ] U = s [ N ] T , Z , N = 0.5 , 0 , 0 s = U ( h , N , T , Z ) W [ g ] = s W = R [ M [ 7 ] ] T = "\\xC0\\xF8\\xF6\\xD9"
                                        --[[P(40811)->[470]]
                                        U = R [ M [ 3 ] ] s = R [ M [ 4 ] ] Z , o = 21759661500308 , 22612733012257 N = s ( T , Z ) g = U [ N ] N = "string"
                                        --[[P(40888)->[547]]
                                        s = w [ N ] T = R [ M [ 3 ] ] A = "\\x8C[h\\xE8\\x1D\\xDF"
                                        --[[P(40677)->[336]]
                                        Z = R [ M [ 4 ] ] S = Z ( A , o ) e , o = 14098696231333 , 18243620299055 N = T [ S ] U = s [ N ] T = R [ M [ 3 ] ] Z = R [ M [ 4 ] ] A = "\\xE8\\xE9G\\xF3"
                                        --[[P(40894)->[553]]
                                        S = Z ( A , o ) N = T [ S ] S = "math"
                                        --[[P(40389)->[48]]
                                        Z = w [ S ] A = R [ M [ 3 ] ] o = R [ M [ 4 ] ] u = o ( v , e ) S = A [ u ] o = 100 T = Z [ S ] A = h * o o = 0.5 S = A + o h = nil Z = { T ( S ) } s = U ( N , b ( Z ) ) W [ g ] = s W , g = w [ "sr1DbFlk5z4Z"
                                        --[[P(40630)->[289]]
                                        ] , { }
                                    else
                                        g , C = { } , "warn"
                                        --[[P(40734)->[393]]
                                        t = w [ C ] J , x = 7679232167415 , "\\xB2.\\x15\\xB2\\x0C/\\xC2\\xF3A4\\xF5\\xFE\\xC6\\x08\\xDA\\xAD>ya"
                                        --[[P(40597)->[256]]
                                        G = R [ N ] H = R [ U ] E = H ( x , J ) r = G [ E ] C = t ( r ) W = w [ "65u43s66yN9Yq"
                                        --[[P(40608)->[267]]
                                        ]
                                    end
                                else
                                    if 5874898 > W then
                                        U , g , s = "6aWTBF8pl3v4XR"
                                        --[[P(40704)->[363]]
                                        , 12929964 , 4579964 h = U ^ s W = g - h g , h = "i2DL6skadDaig7q"
                                        --[[P(40915)->[574]]
                                        , W W = g / h g = { W } W = w [ "ewqTlKNYEtsR6"
                                        --[[P(40707)->[366]]
                                        ]
                                    elseif W < 6007660 then
                                        g , S = 0 , s W = S == g W = W and 14920708 or 5496486
                                    elseif W < - 7810350 then
                                        I = 1 t = # v e = u ( I , t ) I = o ( v , e ) t = R [ A ] r , e = 1 , nil d = I - r C = s ( d ) t [ I ] = C d , I = 0 , nil C = # v t = C == d W = t and 7433022 or 6036205
                                    else
                                        W = g and 12434097 or 6382631
                                    end
                                end
                            else
                                if W > 6799365 then
                                    if W < 6938929 then
                                        g , W = { } , w [ "i10l5hpaHMuz"
                                        --[[P(40711)->[370]]
                                        ]
                                    elseif 7015539 > W then
                                        A = "Enum"
                                        --[[P(41057)->[716]]
                                        S = w [ A ] W = 12406193 o = R [ M [ 1 ] ] e , I = "|\\x1D\\xAC\\xCB#\\xBF\\xDE\\xB1BD`I\\xDB\\xB2"
                                        --[[P(40785)->[444]]
                                        , 27654990279245 u = R [ M [ 2 ] ] v = u ( e , I ) A = o [ v ] e = 10817712231341 Z = S [ A ] A = R [ M [ 1 ] ] o = R [ M [ 2 ] ] v = "\\xC6\\xF9V6;H"
                                        --[[P(40600)->[259]]
                                        u = o ( v , e ) S = A [ u ] T = Z [ S ] g = T
                                    elseif 7100446 > W then
                                        r = R [ N ] I = W G = R [ U ] x , E = 4566595373134 , "\\xC0\\xB8{U\\x9AF\\x98\\xDC\\xB5"
                                        --[[P(40502)->[161]]
                                        H = G ( E , x ) C = r [ H ] t = u [ C ] W , e = t and 16148928 or 1196584 , t
                                    else
                                        U = f ( ) s = Q ( 9343361 , { M [ 1 ] ;
                                        M [ 2 ] , U } ) g , W = "pcall"
                                        --[[P(40547)->[206]]
                                        , nil R [ U ] = W W = w [ g ] g = W ( s ) W = R [ U ] W = W and 2586064 or 10832111
                                    end
                                else
                                    if W < 6542741 then
                                        g = "gethui"
                                        --[[P(40604)->[263]]
                                        W = w [ g ] g = W ( ) W = 13400061 R [ M [ 3 ] ] = g
                                    elseif 6623551 > W then
                                        g , W = { } , w [ "ScTfBrCxeNvRo"
                                        --[[P(40757)->[416]]
                                        ]
                                    elseif - 7765777 > W then
                                        k = W bR = R [ U ] W , g = bR and 3549479 or 7594204 , bR
                                    else
                                        g , W = { } , w [ "NoG5IOCJshWNO"
                                        --[[P(40862)->[521]]
                                        ]
                                    end
                                end
                            end
                        end
                    end
                end
            else
                if W < - 12849423 then
                    if W > 10729490 then
                        if W < 11487992 then
                            if - 12714984 > W then
                                if 10841067 > W then
                                    if W < 10778355 then
                                        e , S , I , A = "\\xCD\\x08\\x88\\x05"
                                        --[[P(40798)->[457]]
                                        , N , 18063688655067 , "string"
                                        --[[P(40888)->[547]]
                                        g = w [ A ] o = R [ M [ 1 ] ] u = R [ M [ 2 ] ] t = "\\xDA\\xA1\\xA2\\xA7\\xB6\\x99"
                                        --[[P(41061)->[720]]
                                        v = u ( e , I ) u , p = "math"
                                        --[[P(40389)->[48]]
                                        , 33503604964593 A = o [ v ] W = g [ A ] o = w [ u ] v = R [ M [ 1 ] ] e = R [ M [ 2 ] ] I = e ( t , p ) u = v [ I ] v = 122 A = o [ u ] u = 97 o = { A ( u , v ) } g = W ( b ( o ) ) W = 7671208 U [ S ] = g S = nil
                                    elseif - 11610424 > W then
                                        g = "pcall"
                                        --[[P(40547)->[206]]
                                        h = f ( ) W = nil R [ h ] = W U = a ( 16525217 , { M [ 1 ] ;
                                        M [ 2 ] , h } ) Z , S = "\\x83\\xF2E\\xF5\\x0E\\xAB\\x90`"
                                        --[[P(40549)->[208]]
                                        , 5967518829274 W = w [ g ] g = W ( U ) U = "typeof"
                                        --[[P(40601)->[260]]
                                        g = w [ U ] s = R [ h ] U = g ( s ) s = R [ M [ 1 ] ] N = R [ M [ 2 ] ] T = N ( Z , S ) g = s [ T ] W = U == g W = W and 13155724 or 7168825
                                    elseif 10827831 > W then
                                        W , g = 3599116 < - 13314112 , { } R [ M [ 1 ] ] = W W = w [ "Jw11SzHU1hht"
                                        --[[P(40449)->[108]]
                                        ]
                                    else
                                        A = 3630013482650 W = R [ M [ 3 ] ] S = "\\xC0\\x8A\\xB7\\x18>\\xBF\\xB8\\xD4\\xC7"
                                        --[[P(40752)->[411]]
                                        N = R [ M [ 1 ] ] T = R [ M [ 2 ] ] Z = T ( S , A ) s = N [ Z ] N = "WaitForChild"
                                        --[[P(40461)->[120]]
                                        N = W [ N ] g = { N ( W , s ) } g , W = { b ( g ) } , w [ "iqpzwjeGRLAjQz"
                                        --[[P(40441)->[100]]
                                        ]
                                    end
                                else
                                    if 10856822 > W then
                                        W = 12624498 < - 5708811 R [ U ] = W W = 11740481
                                    elseif W < 10882615 then
                                        N = nil U = R [ M [ 1 ] ] h = # U s = R [ M [ 1 ] ] U = s [ h ] s = R [ M [ 1 ] ] g = { U } s [ h ] = N W = w [ "uBXnvnjSt4Q3H"
                                        --[[P(40758)->[417]]
                                        ]
                                    elseif W < 10907516 then
                                        W = m W , g = 7594204 , bR
                                    else
                                        K , o = "string"
                                        --[[P(40888)->[547]]
                                        , v j = w [ K ] K = "byte"
                                        --[[P(40629)->[288]]
                                        D = j [ K ] j = D ( h , o ) D = R [ M [ 6 ] ] K = D ( ) W = 13566339 C = j + K p = C + S j , C = 1 , 256 t = p % C S = t D = S + j o = nil C = N [ D ] p = A .. C A = p
                                    end
                                end
                            else
                                if W > 11357480 then
                                    if 11408158 > W then
                                        h = R [ M [ 1 ] ] W , g = h and - 2650011 or 7653137 , h
                                    elseif W < 11435924 then
                                        W = R [ M [ 2 ] ] h = R [ M [ 3 ] ] N , T = "G\\xE2PW"
                                        --[[P(40587)->[246]]
                                        , 31812654873053 U = R [ M [ 4 ] ] s = U ( N , T ) g = h [ s ] h = R [ M [ 5 ] ] o = 24842514623792 W [ g ] = h S = "a0\\x9E\\xFB\\xB8\\xAC\\x86d\\xF6k"
                                        --[[P(41063)->[722]]
                                        W = R [ M [ 2 ] ] A , T = 13880983935295 , 6724142976059 h = R [ M [ 3 ] ] N = "\\x08k\\xB1\\xC3gt\\xC6t"
                                        --[[P(40397)->[56]]
                                        U = R [ M [ 4 ] ] s = U ( N , T ) g = h [ s ] s = "UDim2"
                                        --[[P(40720)->[379]]
                                        U = w [ s ] I = "\\xA3\\x83k\\x89\\xD6\\xC0\\x0F\\xE5;\\xAA"
                                        --[[P(40430)->[89]]
                                        N = R [ M [ 3 ] ] T = R [ M [ 4 ] ] Z = T ( S , A ) s = N [ Z ] N = 58 h = U [ s ] s = 94 U = h ( s , N ) A = "YoE\\xE7C\\x8F`\\x14J\\xD1\\xBA\\x06z\\xAC\\xF7\\xFF"
                                        --[[P(40895)->[554]]
                                        W [ g ] = U W = R [ M [ 6 ] ] h = R [ M [ 2 ] ] u = ":\\xCD\\x81\\x0F\\xCCY\\xC7\\xB0"
                                        --[[P(40964)->[623]]
                                        T = R [ M [ 3 ] ] U = .35 Z = R [ M [ 4 ] ] S = Z ( A , o ) N = T [ S ] S = R [ M [ 3 ] ] T = 0 A = R [ M [ 4 ] ] v = 30572545341340 o = A ( u , v ) Z = S [ o ] t , o = 19259823055624 , "UDim2"
                                        --[[P(40720)->[379]]
                                        A = w [ o ] u = R [ M [ 3 ] ] v = R [ M [ 4 ] ] e = v ( I , t ) o = u [ e ] S = A [ o ] v , o , u = "\\xC0O\\xA4M/\\xB03P\\xEA\\x15\\xCF"
                                        --[[P(40521)->[180]]
                                        , 94 , 52 A = S ( o , u ) s , S = { [ N ] = T , [ Z ] = A } , "Enum"
                                        --[[P(41057)->[716]]
                                        Z = w [ S ] e = 25999821877067 A = R [ M [ 3 ] ] o = R [ M [ 4 ] ] u = o ( v , e ) S = A [ u ] u = "\\xB7\\x89\\xA0U"
                                        --[[P(40867)->[526]]
                                        T = Z [ S ] S = R [ M [ 3 ] ] v = 32808885058477 A = R [ M [ 4 ] ] o = A ( u , v ) Z = S [ o ] N = T [ Z ] g = W ( h , U , s , N ) g , W = { } , w [ "8C8xW3srj2hmH7"
                                        --[[P(40927)->[586]]
                                        ]
                                    elseif W < 11473729 then
                                        s = R [ M [ 1 ] ] o , A = 573525377291 , "\\xEF=\\x11\\xC2Z\\x93\\xC3Q{\\xC1\t"
                                        --[[P(40826)->[485]]
                                        T = R [ M [ 2 ] ] Z = R [ M [ 3 ] ] S = Z ( A , o ) N = T [ S ] U = s [ N ] W , s = 13190025 , nil h = U ~= s g = h
                                    else
                                        W = 14549158
                                    end
                                else
                                    if W < 10947987 then
                                        h = R [ M [ 1 ] ] g , W = h , h and 10402853 or 14762014
                                    elseif W < 11111592 then
                                        U , S = "task"
                                        --[[P(40721)->[380]]
                                        , 35019003641778 h = w [ U ] Z = "\\xA5\\xDF\\xE6\\x12"
                                        --[[P(40627)->[286]]
                                        s = R [ M [ 7 ] ] N = R [ M [ 8 ] ] T = N ( Z , S ) U = s [ T ] g = h [ U ] U = .34 h = g ( U ) h = "pcall"
                                        --[[P(40547)->[206]]
                                        U = c ( 16612205 , { M [ 13 ] } ) g = w [ h ] h = g ( U ) g = R [ M [ 12 ] ] W = g and 12343378 or 6719882
                                    elseif W < 11292289 then
                                        W , g = w [ "bMCWxy0gpPaQ9h"
                                        --[[P(40858)->[517]]
                                        ] , { }
                                    else
                                        g = R [ M [ 19 ] ] W = w [ "aVz3WGxXC6Z8T"
                                        --[[P(40728)->[387]]
                                        ] Z = g ( N ) g = { }
                                    end
                                end
                            end
                        else
                            if W < 11982678 then
                                if W > - 13098570 then
                                    if 11723316 > W then
                                        W , g = w [ "CiRyqfejzZw64"
                                        --[[P(40863)->[522]]
                                        ] , { }
                                    elseif 11772219 > W then
                                        W , S = 12639664 , nil
                                    elseif - 13311366 > W then
                                        h , Z = "Vector2"
                                        --[[P(40861)->[520]]
                                        , 1827434726226 g = w [ h ] T = "s1o"
                                        --[[P(40525)->[184]]
                                        U = R [ M [ 1 ] ] s = R [ M [ 2 ] ] N = s ( T , Z ) h = U [ N ] U = 600 W = g [ h ] h = 800 g = W ( h , U ) h = f ( ) R [ h ] = g g = "pcall"
                                        --[[P(40547)->[206]]
                                        W = w [ g ] U = c ( 3702371 , { M [ 1 ] , M [ 2 ] ;
                                        h } ) g = W ( U ) W = R [ h ] g = { W } W = w [ "InRyo6EJCUn0IW"
                                        --[[P(40545)->[204]]
                                        ]
                                    else
                                        j = R [ U ] D , p = W , j W = j and 1412384 or 13090432
                                    end
                                else
                                    if W < - 12793032 then
                                        W = 1385256 Z = R [ s ] N = Z
                                    elseif 11543588 > W then
                                        S , o = nil , A A , N , Z = nil , nil , nil s [ U ] = o W = 4906190
                                    elseif W < 11584997 then
                                        S = 11418785977541 U = c ( 3425667 , { M [ 2 ] } ) g = "pcall"
                                        --[[P(40547)->[206]]
                                        W = w [ g ] Z = "\\xB8\\x08\\x99 3\\xCA\\x14\\x1A\\xFA\\x9A:7\\xD9\\xE4/\\x0D\\xB6~\\x11\\xAE\\x12E\\xF1pt\\x9DNG"
                                        --[[P(40924)->[583]]
                                        g = W ( U ) W = R [ M [ 3 ] ] s = R [ M [ 4 ] ] N = R [ M [ 5 ] ] T = N ( Z , S ) Z = 30762026612724 U = s [ T ] g = W ( U ) T = "\\x88\\xE4\\x084"
                                        --[[P(40598)->[257]]
                                        W = R [ M [ 6 ] ] U = R [ M [ 4 ] ] s = R [ M [ 5 ] ] N = s ( T , Z ) S = 20729108014516 g = U [ N ] s = R [ M [ 4 ] ] N = R [ M [ 5 ] ] Z = "p\\xBA\\xB6\\xE5@"
                                        --[[P(40740)->[399]]
                                        T = N ( Z , S ) Z = 22439571073233 U = s [ T ] W [ g ] = U W = R [ M [ 6 ] ] e , A = "\\xACT\\xD1c\\x19\\xCCL.\\x94"
                                        --[[P(41014)->[673]]
                                        , "\\xC7l\\xC9MU"
                                        --[[P(40996)->[655]]
                                        U = R [ M [ 4 ] ] s = R [ M [ 5 ] ] T = "\\xE3\\x02s\\x90\\x81\\xB7\\xEE\\x90tB"
                                        --[[P(40511)->[170]]
                                        N = s ( T , Z ) o = 26716323754136 g = U [ N ] s = R [ M [ 7 ] ] T = R [ M [ 4 ] ] Z = R [ M [ 5 ] ] S = Z ( A , o ) N = T [ S ] U = s [ N ] W [ g ] = U T = "\\x13\\xD4A\\xB9\\xEBL\\xFE\\x0B\\x0E\\xBAX/\\xC7\\x9D\t\\x07"
                                        --[[P(41038)->[697]]
                                        W = R [ M [ 8 ] ] U = R [ M [ 4 ] ] Z = 27282717356448 s = R [ M [ 5 ] ] o = 27968414560991 N = s ( T , Z ) A = "\\xB6\\x03O\\x875"
                                        --[[P(40892)->[551]]
                                        g = U [ N ] s = R [ M [ 7 ] ] T = R [ M [ 4 ] ] Z = R [ M [ 5 ] ] S = Z ( A , o ) A = "s=\\xC0]0"
                                        --[[P(40387)->[46]]
                                        N = T [ S ] U = s [ N ] u = 16556506258973 W [ g ] = U Z = 9245910274257 W = R [ M [ 9 ] ] U = R [ M [ 4 ] ] T = "\\x1A:d\\x02\\xC6t\\x16$e\\xBE\\x04\\xD7>P|d"
                                        --[[P(41020)->[679]]
                                        s = R [ M [ 5 ] ] N = s ( T , Z ) g = U [ N ] s = R [ M [ 7 ] ] T = R [ M [ 4 ] ] Z = R [ M [ 5 ] ] o = 21264687589038 S = Z ( A , o ) N = T [ S ] o = "W\\xA8\\x91\\xD0"
                                        --[[P(40654)->[313]]
                                        U = s [ N ] W [ g ] = U s = 0.25 W = R [ M [ 10 ] ] U = R [ M [ 8 ] ] Z = R [ M [ 4 ] ] I = 5874193042095 S = R [ M [ 5 ] ] A = S ( o , u ) T = Z [ A ] A = "UDim2"
                                        --[[P(40720)->[379]]
                                        S = w [ A ] o = R [ M [ 4 ] ] u = R [ M [ 5 ] ] v = u ( e , I ) A = o [ v ] Z = S [ A ] o , A = 1 , 1 S = Z ( A , o ) N = { [ T ] = S } g = W ( U , s , N ) g , A = "warn"
                                        --[[P(40734)->[393]]
                                        , 27988830581481 W = w [ g ] N = R [ M [ 4 ] ] S = "[v=9nh\\xD6\\xEC\\xFA\\xD2"
                                        --[[P(41087)->[746]]
                                        T = R [ M [ 5 ] ] Z = T ( S , A ) s = N [ Z ] T = "tostring"
                                        --[[P(40573)->[232]]
                                        N = w [ T ] T = N ( h ) U = s .. T g = W ( U ) U , Z , h = "task"
                                        --[[P(40721)->[380]]
                                        , "\\xE6\\xE8\\x8D\\xAA"
                                        --[[P(40963)->[622]]
                                        , nil g = w [ U ] s = R [ M [ 4 ] ] N = R [ M [ 5 ] ] S = 30437490210653 T = N ( Z , S ) U = s [ T ] W = g [ U ] U = 1.8 g = W ( U ) W = R [ M [ 11 ] ] g = W ( ) W , g = w [ "18L7qrTxO5rP6j"
                                        --[[P(40418)->[77]]
                                        ] , { }
                                    else
                                        s , S = T + s , not Z U = s <= N U = S and U S = N <= s S = Z and S U = S or U S = 7659037 W = U and S U = 7287991 W = W or U
                                    end
                                end
                            else
                                if W < 12313311 then
                                    if 12107095 > W then
                                        s = "table"
                                        --[[P(40781)->[440]]
                                        g = w [ s ] A , S = 32235748178594 , "6\\x04\\x95\\xFEO("
                                        --[[P(40366)->[25]]
                                        N = R [ M [ 1 ] ] T = R [ M [ 2 ] ] Z = T ( S , A ) s = N [ Z ] W = g [ s ] g = { W ( U ) } g , W = { b ( g ) } , w [ "JWgGfcYQcryN"
                                        --[[P(40390)->[49]]
                                        ]
                                    elseif 12221054 > W then
                                        o = 3862459041542 g = R [ M [ 16 ] ] T = R [ M [ 4 ] ] A = "\\xA1\\xE7\\x81Wg\\xC7\\x92xJ\\xCF\\x0C]\\xEF\\x1ESU/\\xFFq\\x1F\\xFFI\\xD3;\\xEE\\xEC"
                                        --[[P(40689)->[348]]
                                        Z = R [ M [ 5 ] ] S = Z ( A , o ) N = T [ S ] U = g ( N ) N , T = .72 , .42 g = R [ M [ 17 ] ] U = g ( N , T ) A , N , o = "n\\xA7u\\xD4"
                                        --[[P(40623)->[282]]
                                        , "task"
                                        --[[P(40721)->[380]]
                                        , 13143327660008 U = w [ N ] T = R [ M [ 4 ] ] Z = R [ M [ 5 ] ] S = Z ( A , o ) N = T [ S ] g = U [ N ] N = .32 U = g ( N ) A , Z , N = "\\x0Dz\\x8D\\x849.\\x05\\x17"
                                        --[[P(40473)->[132]]
                                        , "loadstring"
                                        --[[P(40396)->[55]]
                                        , "type"
                                        --[[P(40581)->[240]]
                                        U = w [ N ] T = w [ Z ] N = U ( T ) o = 7001786207420 T = R [ M [ 4 ] ] Z = R [ M [ 5 ] ] S = Z ( A , o ) U = T [ S ] g = N ~= U W = g and 2326452 or 13479393
                                    elseif 12270981 > W then
                                        T = 5361739139520 W = R [ M [ 1 ] ] h = R [ M [ 2 ] ] N = "T\\x96\\x1A(\\xEB\\x95"
                                        --[[P(40827)->[486]]
                                        U = R [ M [ 3 ] ] s = U ( N , T ) g = h [ s ] h = R [ M [ 4 ] ] U = h ( ) W [ g ] = U W , g = w [ "NnJpb7cYe6Pitx"
                                        --[[P(40572)->[231]]
                                        ] , { }
                                    else
                                        W , s , S , v = Z , { [ N ] = T } , "Enum"
                                        --[[P(41057)->[716]]
                                        , "=\"\\xF6!\\xEDr>\\xFECYG"
                                        --[[P(40962)->[621]]
                                        Z = w [ S ] A = R [ M [ 3 ] ] o = R [ M [ 4 ] ] e = 8691684773839 u = o ( v , e ) S = A [ u ] v = 14311826496008 T = Z [ S ] u = "W\\x15^\\xC2T;"
                                        --[[P(40357)->[16]]
                                        S = R [ M [ 3 ] ] A = R [ M [ 4 ] ] o = A ( u , v ) Z = S [ o ] N = T [ Z ] g = W ( h , U , s , N ) W = 16581772
                                    end
                                else
                                    if W < - 13821084 then
                                        S , U = 32927355911140 , "task"
                                        --[[P(40721)->[380]]
                                        h = w [ U ] s = R [ M [ 7 ] ] N = R [ M [ 8 ] ] Z = "Zi&\\x83}"
                                        --[[P(40376)->[35]]
                                        T = N ( Z , S ) U = s [ T ] g = h [ U ] W = 6719882 s = O ( 1268774 , { M [ 12 ] } ) U = .1 h = g ( U , s )
                                    elseif W < 12383378 then
                                        v , W = 3 , o o = f ( ) R [ o ] = g g = R [ S ] e = 65 u = g ( v , e ) v = f ( ) R [ v ] = u g = 0 u , t = g , "pcall"
                                        --[[P(40547)->[206]]
                                        g , W = 0 , 1416181 I = w [ t ] e = g p = c ( 5770682 , { } ) K = "tostring"
                                        --[[P(40573)->[232]]
                                        t = { I ( p ) } g = { b ( t ) } t , I , p = 2 , g , "tonumber"
                                        --[[P(40675)->[334]]
                                        g = I [ t ] t = g g = w [ p ] C = R [ s ] j = w [ K ] K = j ( t ) j = ":(%d*):"
                                        --[[P(40650)->[309]]
                                        D = C ( K , j ) C = { D ( ) } p = g ( b ( C ) ) C = f ( ) R [ C ] = p p = R [ v ] g , D = 1 , p p = 1 j = p p = 0 K = j < p p = g - j
                                    else
                                        S , u , W = 15728595786908 , "\\x13\\xF3G\\x10\\x9D\\xA2P\\xB7@\\xEE\\xE5\\xE2"
                                        --[[P(40565)->[224]]
                                        , N s [ W ] = g g = R [ M [ 1 ] ] N = R [ M [ 2 ] ] Z , v = "HI\\x9B\\xF2(\\xB7\\x9D\\x0D'\\x9F\\x1Cx"
                                        --[[P(40724)->[383]]
                                        , 7955419631224 T = N ( Z , S ) W = g [ T ] N = W S = R [ M [ 1 ] ] A = R [ M [ 2 ] ] o = A ( u , v ) Z = S [ o ] T = s [ Z ] g , W = T , T and 1551787 or 8000215
                                    end
                                end
                            end
                        end
                    else
                        if 9538990 > W then
                            if W > 8905220 then
                                if W > - 9438176 then
                                    if 9294083 > W then
                                        S = R [ s ] I = 21340805375697 o = R [ M [ 4 ] ] u = R [ M [ 5 ] ] e = ""
                                        --[[P(41011)->[670]]
                                        v = u ( e , I ) W = 9978740 A = o [ v ] Z = S == A N = Z
                                    elseif W < 9337927 then
                                        g = "loadstring"
                                        --[[P(40396)->[55]]
                                        W = w [ g ] h = R [ M [ 1 ] ] g = { W ( h ) } g , W = { b ( g ) } , w [ "SqrQUO0cliv6"
                                        --[[P(40594)->[253]]
                                        ]
                                    elseif 9356917 > W then
                                        g = "game"
                                        --[[P(40378)->[37]]
                                        W = w [ g ] T = "\\xC7\\xAF.?\\xEFGj"
                                        --[[P(40520)->[179]]
                                        U = R [ M [ 1 ] ] s = R [ M [ 2 ] ] g , Z = "GetService"
                                        --[[P(40672)->[331]]
                                        , 31905327020553 N = s ( T , Z ) h = U [ N ] g = W [ g ] g = g ( W , h ) R [ M [ 3 ] ] = g g , W = { } , w [ "hdwuZDfJ7VLZ"
                                        --[[P(40767)->[426]]
                                        ]
                                    else
                                        U , o = .16 , 7312846245197 W = R [ M [ 4 ] ] h = R [ M [ 1 ] ] A = "D&{\\x97\\x82\\x9EOy\\x9E\\x88\\xAB\\x8FD\\xB6\\x17\\xFF"
                                        --[[P(40420)->[79]]
                                        T = R [ M [ 2 ] ] v = "P\\xE0\\xACB\\xDC\\xE8\\x8D\\xF9"
                                        --[[P(40747)->[406]]
                                        Z = R [ M [ 3 ] ] S = Z ( A , o ) N = T [ S ] Z = R [ M [ 5 ] ] A = R [ M [ 2 ] ] e = 19617420059567 o = R [ M [ 3 ] ] u = o ( v , e ) S = A [ u ] A = "\\xA7\\xE9\\xDF\\xC8<\\xFC\\x88\\xC3\\x1C\\xB0\\xBBC"
                                        --[[P(40484)->[143]]
                                        T = Z [ S ] s = { [ N ] = T } g = W ( h , U , s ) U = .16 W = R [ M [ 4 ] ] h = R [ M [ 6 ] ] o = 14995557423942 T = R [ M [ 2 ] ] Z = R [ M [ 3 ] ] S = Z ( A , o ) N = T [ S ] T = .15 s = { [ N ] = T } g = W ( h , U , s ) W = 6547961
                                    end
                                else
                                    if 8921678 > W then
                                        W , t = 13779644 , "table"
                                        --[[P(40781)->[440]]
                                        I = w [ t ] t = "unpack"
                                        --[[P(40797)->[456]]
                                        e = I [ t ] u = e
                                    elseif W < 9011522 then
                                        S , U , h = 12834712622936 , "table"
                                        --[[P(40781)->[440]]
                                        , n [ 1 ] g = w [ U ] s = R [ M [ 1 ] ] Z = "u\\x14\\x83\\x0E8\\x1D"
                                        --[[P(40695)->[354]]
                                        N = R [ M [ 2 ] ] T = N ( Z , S ) U = s [ T ] W = g [ U ] g = W ( h ) U = g g , s , N = 1 , h , 1 T = N N = 0 Z = N > T N , W = g - T , 7671208
                                    elseif 9139102 > W then
                                        v = "\\xA0\\xCE\\x94\\xE8"
                                        --[[P(40537)->[196]]
                                        Z = R [ M [ 4 ] ] e = 32374134848227 A = R [ M [ 1 ] ] o = R [ M [ 2 ] ] u = o ( v , e ) W = 15050091 S = A [ u ] T = Z [ S ] g = T
                                    else
                                        j , D , I = 24201971100677 , "n\\xA3\\x97cm\\xF4\\xBAw\\xA23~"
                                        --[[P(41019)->[678]]
                                        , "Enum"
                                        --[[P(41057)->[716]]
                                        e = w [ I ] t = R [ M [ 2 ] ] p = R [ M [ 3 ] ] C = p ( D , j ) I = t [ C ] W = 2603855 v = e [ I ] D , C = 5839696824991 , "@\\xB8\\x08q\\xCB"
                                        --[[P(41049)->[708]]
                                        I = R [ M [ 2 ] ] t = R [ M [ 3 ] ] p = t ( C , D ) e = I [ p ] u = v [ e ] A = u
                                    end
                                end
                            else
                                if W > 8722948 then
                                    if 8766147 > W then
                                        Z , h , A = 8545818513291 , "task"
                                        --[[P(40721)->[380]]
                                        , "\\xA8#\t |\\xE4\\xA7\\xF7!t\\xAB\\xD1"
                                        --[[P(40859)->[518]]
                                        g = w [ h ] U = R [ M [ 2 ] ] T = "\\xD1T\\xFF\\xD7"
                                        --[[P(40838)->[497]]
                                        s = R [ M [ 3 ] ] N = s ( T , Z ) h = U [ N ] W = g [ h ] h = R [ M [ 4 ] ] g = W ( h ) o = 4828406859976 s = R [ M [ 1 ] ] T = R [ M [ 2 ] ] Z = R [ M [ 3 ] ] S = Z ( A , o ) N = T [ S ] U = s [ N ] s = 2354481 < - 9022692 h = U ~= s g , W = h , h and 10073132 or 1734600
                                    elseif W < 8814919 then
                                        W = N s [ W ] = g g = R [ M [ 1 ] ] Z = "\\x85\\xB5\\x82\\xD3\\xC9\\xCB\\x16k"
                                        --[[P(41009)->[668]]
                                        N = R [ M [ 2 ] ] S , u = 32051978893901 , "\\xA7f\\x91\\xB2\\xCC\\x894T"
                                        --[[P(41000)->[659]]
                                        T = N ( Z , S ) v = 16976130793185 W = g [ T ] N = W S = R [ M [ 1 ] ] A = R [ M [ 2 ] ] o = A ( u , v ) Z = S [ o ] T = s [ Z ] W , g = T and 3768888 or 4143800 , T
                                    elseif W < 8872019 then
                                        g , h = "l2"
                                        --[[P(40709)->[368]]
                                        , "l1"
                                        --[[P(40370)->[29]]
                                        W = w [ g ] g = w [ h ] h = "l1"
                                        --[[P(40370)->[29]]
                                        w [ h ] = W h = "l2"
                                        --[[P(40709)->[368]]
                                        w [ h ] = g h = R [ M [ 1 ] ] W = 15567005 U = h ( )
                                    else
                                        S = R [ M [ 1 ] ] A = R [ M [ 2 ] ] u , v = "%\\x99=\\xC4\t\\x8A\\x12t\\xFA\\x8B\\xAF\\x855\\xAB\\xE8\\xB5\\xF7QR.@0"
                                        --[[P(40890)->[549]]
                                        , 24073799183306 o = A ( u , v ) Z = S [ o ] T = s [ Z ] W , g = 8786989 , T
                                    end
                                else
                                    if W < - 10603049 then
                                        h = f ( ) R [ h ] = n [ 1 ] g = R [ M [ 1 ] ] W = not g W = W and - 5020067 or 12483191
                                    elseif 8635743 > W then
                                        o = 22435538872527 W = R [ M [ 5 ] ] A = "\\x1F~18\\x7F\\x1F\\xB0V\\xE0\\xD25\\xEB|bA8\\xE2\\x0BJ"
                                        --[[P(40830)->[489]]
                                        h = R [ M [ 6 ] ] U , p = .45 , "|\\xE2\\xA09"
                                        --[[P(41084)->[743]]
                                        T = R [ M [ 3 ] ] C = 5065916205367 Z = R [ M [ 4 ] ] I = "9\\x89["
                                        --[[P(40384)->[43]]
                                        S = Z ( A , o ) N = T [ S ] Z , o = W , "utf8"
                                        --[[P(40626)->[285]]
                                        A = w [ o ] t = 15907642301679 u = R [ M [ 3 ] ] v = R [ M [ 4 ] ] e = v ( I , t ) o = u [ e ] S = A [ o ] u = R [ M [ 6 ] ] e = R [ M [ 3 ] ] I = R [ M [ 4 ] ] t = I ( p , C ) v = e [ t ] o = u [ v ] A = S ( o ) W , T = A and 12283244 or 13137072 , A
                                    elseif W < - 9950842 then
                                        m = R [ U ] k , bR = m , W W = m and 2117651 or - 9623493
                                    else
                                        W = g and - 2631618 or - 12459838
                                    end
                                end
                            end
                        else
                            if W > 10148212 then
                                if W < 10468464 then
                                    if 10240533 > W then
                                        S = "\\xF2\\x15\\xF5&\\x93e"
                                        --[[P(40447)->[106]]
                                        U = R [ M [ 2 ] ] A , W = 28214231855954 , 2768495 N = R [ M [ 3 ] ] T = R [ M [ 4 ] ] Z = T ( S , A ) s = N [ Z ] h = U [ s ] g = h
                                    elseif W < 10277875 then
                                        W , A = Z , "math"
                                        --[[P(40389)->[48]]
                                        S = w [ A ] A , o , Z = "random"
                                        --[[P(40943)->[602]]
                                        , "table"
                                        --[[P(40781)->[440]]
                                        , g g = S [ A ] S = f ( ) R [ S ] = g A = w [ o ] I , o = "table"
                                        --[[P(40781)->[440]]
                                        , "concat"
                                        --[[P(40887)->[546]]
                                        g = A [ o ] v = W e = w [ I ] A , u , o = g , e , W W = e and 8909251 or - 15108298
                                    elseif W < 10350415 then
                                        o = "\\x1B\\xF4y3"
                                        --[[P(40933)->[592]]
                                        g = R [ M [ 5 ] ] W = 10948612 U = R [ M [ 12 ] ] Z = R [ M [ 7 ] ] s = .35 S = R [ M [ 8 ] ] u = 23123201321487 A = S ( o , u ) T = Z [ A ] Z = 0 N = { [ T ] = Z } h = g ( U , s , N )
                                    else
                                        W = g and 2486982 or 13805665
                                    end
                                else
                                    if W < 10555420 then
                                        W = R [ M [ 1 ] ] o , S = "Og\\x91\\xFA\\xE6\\xABc\\xDF/\\xB3\\xFA\\xFB"
                                        --[[P(40508)->[167]]
                                        , "\\xE69\\xE1c\"?~U"
                                        --[[P(40503)->[162]]
                                        N = R [ M [ 2 ] ] U , A = n [ 2 ] , 29174919804177 T = R [ M [ 3 ] ] e = "\\xEC1\\xF7"
                                        --[[P(40984)->[643]]
                                        Z = T ( S , A ) s = N [ Z ] h , u = n [ 1 ] , 11622704485668 Z = R [ M [ 2 ] ] S = R [ M [ 3 ] ] A = S ( o , u ) T = Z [ A ] I , A = 8056101326503 , "UDim"
                                        --[[P(40661)->[320]]
                                        S = w [ A ] o = R [ M [ 2 ] ] u = R [ M [ 3 ] ] v = u ( e , I ) u = W A = o [ v ] Z = S [ A ] v = 10 o , A = U or v , 0 S = Z ( A , o ) N = { [ T ] = S } g = { W ( s , N , h ) } W , g = w [ "DUbYKwGDKU4gH"
                                        --[[P(40518)->[177]]
                                        ] , { b ( g ) }
                                    elseif W < 10638072 then
                                        g , W = { } , w [ "0Xv9ejgdQ5wUf"
                                        --[[P(40478)->[137]]
                                        ]
                                    elseif W < 10707385 then
                                        Z , T = h , W g = R [ M [ 19 ] ] S = W W = h and 13013507 or 2560368
                                    else
                                        s = R [ M [ 2 ] ] A , o = "h\\x86XB\\xFEO"
                                        --[[P(40365)->[24]]
                                        , 28491787170771 T = R [ M [ 3 ] ] Z = R [ M [ 4 ] ] S = Z ( A , o ) N = T [ S ] W = 6075276 U = s [ N ] h = not U g = h
                                    end
                                end
                            else
                                if W > 9807282 then
                                    if 9849203 > W then
                                        s , Z = "typeof"
                                        --[[P(40601)->[260]]
                                        , "syn"
                                        --[[P(40937)->[596]]
                                        U = w [ s ] T = w [ Z ] S = R [ M [ 1 ] ] u = "\\xCB\\xFE\\x11\\xE9h\\x9E\\xDD:H\\xA5)"
                                        --[[P(40882)->[541]]
                                        A = R [ M [ 2 ] ] v = 8171976396509 o = A ( u , v ) Z = S [ o ] S , W = "\\xBDx\\x98T\n!\\xFF\\xE3"
                                        --[[P(40595)->[254]]
                                        , 1014331 N = T [ Z ] s = U ( N ) A = 20564860888424 N = R [ M [ 1 ] ] T = R [ M [ 2 ] ] Z = T ( S , A ) U = N [ Z ] h = s == U g = h
                                    elseif W < - 10733335 then
                                        W = 2284562
                                    elseif W < 10025936 then
                                        W = T W , g = 814227 , N
                                    else
                                        W = g and 1832632 or 16235214
                                    end
                                else
                                    if 9717177 > W then
                                        g , s , U = 2698187 , 1692100 , "EG5"
                                        --[[P(40772)->[431]]
                                        h = U ^ s W = g - h h , g = W , "tnTWlh5Pse"
                                        --[[P(41068)->[727]]
                                        W = g / h g = { W } W = w [ "X6yV7ukgNyXka7"
                                        --[[P(40794)->[453]]
                                        ]
                                    elseif 9729222 > W then
                                        S = 31312530536693 W = R [ M [ 1 ] ] g = W ( ) v , U , h , Z = 35106931261403 , "math"
                                        --[[P(40389)->[48]]
                                        , g , "f\\xA0\\xE3\\x0D\\xE9"
                                        --[[P(40923)->[582]]
                                        g = w [ U ] s = R [ M [ 2 ] ] o = 4414529538055 N = R [ M [ 3 ] ] T = N ( Z , S ) A = "\"\\xFA\\xA9"
                                        --[[P(40431)->[90]]
                                        U = s [ T ] W = g [ U ] u , N = "\\xEB"
                                        --[[P(40972)->[631]]
                                        , "math"
                                        --[[P(40389)->[48]]
                                        s = w [ N ] T = R [ M [ 2 ] ] Z = R [ M [ 3 ] ] S = Z ( A , o ) N = T [ S ] U = s [ N ] S = R [ M [ 2 ] ] A = R [ M [ 3 ] ] o = A ( u , v ) v = "N"
                                        --[[P(41075)->[734]]
                                        Z = S [ o ] T = h [ Z ] e , Z = 1901981926261 , 420 N = T / Z A = R [ M [ 2 ] ] o = R [ M [ 3 ] ] u = o ( v , e ) S = A [ u ] Z = h [ S ] S = 305 T = Z / S s = U ( N , T ) N , U = 1 , .7 g = { W ( s , U , N ) } W , g = w [ "qXWGwBnPreVBe"
                                        --[[P(40505)->[164]]
                                        ] , { b ( g ) }
                                    elseif 9765762 > W then
                                        g , W = { } , w [ "NVaFeGmuME7E"
                                        --[[P(40457)->[116]]
                                        ]
                                    else
                                        g = R [ M [ 19 ] ] A = g ( S ) W , g = w [ "rwunC3zT1BVo5"
                                        --[[P(40900)->[559]]
                                        ] , { }
                                    end
                                end
                            end
                        end
                    end
                else
                    if W < 13763229 then
                        if W > 13143589 then
                            if - 15366156 > W then
                                if W > 13187890 then
                                    if W < - 13271188 then
                                        W = g and 8745305 or - 5397552
                                    elseif W < 13310252 then
                                        D , C = 24160049556466 , "\\xC5\\xBBEX_\\xF5"
                                        --[[P(40889)->[548]]
                                        v = R [ M [ 4 ] ] W = 2963803 I = R [ M [ 2 ] ] t = R [ M [ 3 ] ] p = t ( C , D ) e = I [ p ] u = v [ e ] A = u
                                    elseif 13398119 > W then
                                        W = g and - 15007682 or 11274573
                                    else
                                        W , g = w [ "zFZ2IAu7xPeVU"
                                        --[[P(40556)->[215]]
                                        ] , { }
                                    end
                                else
                                    if W < 13152915 then
                                        g , U = "game"
                                        --[[P(40378)->[37]]
                                        , "HttpGet"
                                        --[[P(41018)->[677]]
                                        W = w [ g ] h = R [ M [ 1 ] ] U = W [ U ] g = { U ( W , h ) } g , W = { b ( g ) } , w [ "VXlgOd3Hii1U"
                                        --[[P(40475)->[134]]
                                        ]
                                    elseif W < 13157001 then
                                        W = R [ h ] g = { W } W = w [ "KgSqNRUBiaV6"
                                        --[[P(40342)->[1]]
                                        ]
                                    elseif W < 13172017 then
                                        W = R [ M [ 2 ] ] T , t , v , Z = W , 32600987532109 , 8202141634283 , .65 N , u = U or Z , "\\x8C\\x97&_"
                                        --[[P(40360)->[19]]
                                        s = R [ M [ 3 ] ] S = R [ M [ 4 ] ] A = R [ M [ 5 ] ] o = A ( u , v ) Z = S [ o ] o = "UDim2"
                                        --[[P(40720)->[379]]
                                        A = w [ o ] u = R [ M [ 4 ] ] I = "\\xA0\\xE8\\x97\\xCF\\xDF\\xFCP\\x86\\xA9"
                                        --[[P(40353)->[12]]
                                        v = R [ M [ 5 ] ] e = v ( I , t ) v , C = "math"
                                        --[[P(40389)->[48]]
                                        , 19402173277002 o = u [ e ] S = A [ o ] u = w [ v ] e = R [ M [ 4 ] ] p = "*\\x9D\\xE6\\xA9\\xEE"
                                        --[[P(40834)->[493]]
                                        I = R [ M [ 5 ] ] U = nil t = I ( p , C ) v = e [ t ] e = 1 o = u [ v ] v = 0 u = o ( h , v , e ) o = 1 A = S ( u , o ) t , T , o = 32841797385149 , { [ Z ] = A } , "Enum"
                                        --[[P(41057)->[716]]
                                        A = w [ o ] u = R [ M [ 4 ] ] h , I = nil , "\\xE5\\xC9r\\xF5\\xB43\\x00C)\\xC0\\xA7"
                                        --[[P(40813)->[472]]
                                        v = R [ M [ 5 ] ] e = v ( I , t ) o = u [ e ] I = 17395395633060 S = A [ o ] o = R [ M [ 4 ] ] e = "\\x8E\\x95\\x04\\xB4\\x83"
                                        --[[P(40491)->[150]]
                                        u = R [ M [ 5 ] ] v = u ( e , I ) A = o [ v ] Z = S [ A ] g = W ( s , N , T , Z ) g , W = { } , w [ "6g49pAa9EqWX"
                                        --[[P(40800)->[459]]
                                        ]
                                    else
                                        A , Z = nil , nil o = B ( o ) U = B ( U ) N = B ( N ) v = B ( v ) s = B ( s ) T = B ( T ) e , u = nil , nil u = "string"
                                        --[[P(40888)->[547]]
                                        C = B ( C ) s , I , W = nil , nil , 12813831 N = f ( ) U = nil S = B ( S ) T = f ( ) S = "math"
                                        --[[P(40389)->[48]]
                                        R [ N ] = U A = f ( ) t = nil U = f ( ) R [ U ] = s s = 2 R [ T ] = s Z = w [ S ] S = "floor"
                                        --[[P(40967)->[626]]
                                        s = Z [ S ] S = f ( ) e = "math"
                                        --[[P(40389)->[48]]
                                        Z = f ( ) R [ Z ] = s s = 0 R [ S ] = s s , v = { } , "table"
                                        --[[P(40781)->[440]]
                                        R [ A ] = s o = w [ u ] u = "char"
                                        --[[P(40893)->[552]]
                                        s = o [ u ] u = w [ v ] v = "remove"
                                        --[[P(40391)->[50]]
                                        o = u [ v ] v = w [ e ] e , I = "random"
                                        --[[P(40943)->[602]]
                                        , 256 u = v [ e ] v , t = { } , I I = 1 e , C = 1 , I I = 0 d = I > C I = e - C
                                    end
                                end
                            else
                                if 13547088 > W then
                                    if W < 13458297 then
                                        g , W = { N } , w [ "ZbqK4q3aFp6H"
                                        --[[P(41043)->[702]]
                                        ]
                                    elseif 13478518 > W then
                                        W = 11440749 <= 15169743 W = W and 841677 or 12863111
                                    elseif 13503615 > W then
                                        U = "pcall"
                                        --[[P(40547)->[206]]
                                        g = w [ U ] Z = a ( 9332494 , { s } ) S = { g ( Z ) } T , N , U = S [ 3 ] , S [ 2 ] , S [ 1 ] g = not U W = g and - 12227235 or 8376489
                                    else
                                        W = g and 3870124 or - 11544685
                                    end
                                else
                                    if W < 13572663 then
                                        v = e + v o , t = v <= u , not I o = t and o t = v >= u t = I and t o = t or o t = 10913423 W = o and t o = 11534791 W = W or o
                                    elseif W < 13617012 then
                                        A = R [ U ] o = 2638639 > 4096135 g = A == o W = g and 9883770 or 2284562
                                    elseif W < 13700926 then
                                        g , h , W = 0 , n , "6S"
                                        --[[P(40476)->[135]]
                                        U = f ( ) s = 1 N = s s = 1 R [ U ] = W T , W = s , 12639664 s = 0 Z = s > T s = g - T
                                    else
                                        U = R [ M [ 1 ] ] h = not U g , W = h , h and 6075276 or 10715391
                                    end
                                end
                            end
                        else
                            if W > 12838471 then
                                if W > 13028938 then
                                    if 13052404 > W then
                                        W = R [ M [ 7 ] ] W = W and 5730085 or 14181328
                                    elseif W < 13075435 then
                                        W = 4535225
                                    elseif W < 13113752 then
                                        R [ U ] = p W = D D = R [ U ] W = D and 15271067 or 11486971
                                    else
                                        o = R [ M [ 6 ] ] v = R [ M [ 3 ] ] p = 14533884123759 e = R [ M [ 4 ] ] t = "\\x7F\\x81\\x00\\xF5"
                                        --[[P(40731)->[390]]
                                        I = e ( t , p ) u = v [ I ] A = o [ u ] S = # A T , W = S , 12283244
                                    end
                                else
                                    if 12901250 > W then
                                        W = 10850024
                                    elseif 12966104 > W then
                                        A = 29294828139849 U = R [ M [ 2 ] ] W = 8700592 N = R [ M [ 3 ] ] T = R [ M [ 4 ] ] S = "}6\\xDC\\x82\\x16\\x92"
                                        --[[P(40697)->[356]]
                                        Z = T ( S , A ) s = N [ Z ] h = U [ s ] g = h
                                    elseif 13003163 > W then
                                        e = I r = e v [ e ] = r W , e = 12813831 , nil
                                    else
                                        I = 30449734334307 o = R [ M [ 4 ] ] u = R [ M [ 5 ] ] e = "\\x81_\\xC8\\x90\\xC3wH\\xC5D\\x18\\xB7\\x80n0\\x1F\\x82\\xC2\\xA8m57\\xF0\\xAC\\xB5\\xBD\\x00\\x027TWW!'\\xCD\\xEC+G\\x9B"
                                        --[[P(40754)->[413]]
                                        v = u ( e , I ) A = o [ v ] W , Z = 2560368 , A
                                    end
                                end
                            else
                                if - 12902684 > W then
                                    if W < 12458644 then
                                        g , W = { } , w [ "YEh9Jfg77MjTC"
                                        --[[P(40680)->[339]]
                                        ]
                                    elseif 12492404 > W then
                                        W = R [ M [ 2 ] ] s , v = .12 , "\nf\\xCF\\xB8R#Ar"
                                        --[[P(40450)->[109]]
                                        U = R [ M [ 3 ] ] Z = R [ M [ 4 ] ] o = "K\\xCAq\\xFD8&\\x04\\x7F\\xC6\\xCF=g>\\xA0\\x7F\t"
                                        --[[P(40558)->[217]]
                                        S = R [ M [ 5 ] ] u = 6553609325547 A = S ( o , u ) e = 5528843487758 T = Z [ A ] p , Z = 17713958625336 , 1 A = R [ M [ 4 ] ] o = R [ M [ 5 ] ] u = o ( v , e ) t = "7\\xBA\\xC9\\xF4\\x9A\\xBE\\xA4\\x9E\\x0E="
                                        --[[P(40571)->[230]]
                                        S = A [ u ] u = "UDim2"
                                        --[[P(40720)->[379]]
                                        o = w [ u ] v = R [ M [ 4 ] ] e = R [ M [ 5 ] ] I = e ( t , p ) u = v [ I ] A = o [ u ] v , u = 46 , 94 o = A ( u , v ) N = { [ T ] = Z ;
                                        [ S ] = o } Z , S = "\\xBC\\xF7\\xD2\\xA7\\xFC"
                                        --[[P(40563)->[222]]
                                        , 29166342337805 g = W ( U , s , N ) U = "task"
                                        --[[P(40721)->[380]]
                                        g = w [ U ] s = R [ M [ 4 ] ] N = R [ M [ 5 ] ] T = N ( Z , S ) U = s [ T ] s = O ( 3295510 , { M [ 1 ] , M [ 3 ] , M [ 4 ] , M [ 5 ] , h ;
                                        M [ 2 ] } ) h = B ( h ) W = g [ U ] U = .12 g = W ( U , s ) g , W = { } , w [ "M5Pe6KsM21RkM"
                                        --[[P(40682)->[341]]
                                        ]
                                    elseif - 14081648 > W then
                                        U , Z , h = n [ 2 ] , "\\xDD\\xBD\\xB6\\x8A"
                                        --[[P(41073)->[732]]
                                        , n [ 1 ] g = R [ M [ 1 ] ] s = n [ 3 ] N = R [ M [ 2 ] ] S = 32509296851746 T = N ( Z , S ) S = 14018743933311 W = g [ T ] g , Z = U , "\\x9E2\\xEE\\xA2\\xAD\\xDB\\xE3\\xF6\t\\x96\\xB9\\xFA\\xD573_?\\xA2\\xBF\\xBD\\xE0\\x10"
                                        --[[P(41082)->[741]]
                                        s [ W ] = g g = R [ M [ 1 ] ] t = 28667061646373 N = R [ M [ 2 ] ] T = N ( Z , S ) W = g [ T ] N , Z = W , W u = R [ M [ 1 ] ] I = "\\xC1\\x1A\\xB7\\xAC\\x0CK\\xF4AhO\\x19\\x8B\\x9D\\xA5\\xA6,\\xD4\\x9A\\x97R\\x0E5"
                                        --[[P(40388)->[47]]
                                        v = R [ M [ 2 ] ] e = v ( I , t ) o = u [ e ] A = s [ o ] o = nil S = A == o A = 1 T = S and A W , g = T and 8786989 or - 9372245 , T
                                    else
                                        s , S = s + T , not Z g = N >= s g = S and g S = s >= N S = Z and S g = S or g S = 5979115 W = g and S g = 16743157 W = W or g
                                    end
                                else
                                    if 12695526 > W then
                                        W , g = w [ "gPTcKIDXOuoiZX"
                                        --[[P(40958)->[617]]
                                        ] , { }
                                    elseif 12725963 > W then
                                        W = g and 117106 or 13044370
                                    elseif W < 12780339 then
                                        h = R [ M [ 1 ] ] g , W = h , h and - 11686021 or 2768495
                                    else
                                        I , r = I + C , not d e = t >= I e = r and e r = t <= I r = d and r e = r or e r = 12992820 W = e and r e = 4769582 W = W or e
                                    end
                                end
                            end
                        end
                    else
                        if W < 15398515 then
                            if W > 14567968 then
                                if W > 14924644 then
                                    if 14952981 > W then
                                        W = 10257773 S = R [ T ] g = S
                                    elseif W < 15013736 then
                                        h , W = "pcall"
                                        --[[P(40547)->[206]]
                                        , 7730409 < - 8747617 R [ M [ 1 ] ] = W g = w [ h ] U = a ( 4092048 , { M [ 2 ] } ) s , u = .28 , 19441772569437 h = g ( U ) h = "pcall"
                                        --[[P(40547)->[206]]
                                        U = c ( 14110309 , { M [ 3 ] } ) o = "\\x8F\\xB4\\x1B\\x0C\\xF8\\x16\\xE2\\xC5\\xA5\\xA2\\xE7&\\x068\\x02\\x94)"
                                        --[[P(40592)->[251]]
                                        g = w [ h ] h = g ( U ) h = "pcall"
                                        --[[P(40547)->[206]]
                                        g = w [ h ] U = q ( 5699755 , { M [ 4 ] } ) h = g ( U ) g = R [ M [ 5 ] ] U = R [ M [ 6 ] ] Z = R [ M [ 7 ] ] S = R [ M [ 8 ] ] A = S ( o , u ) T = Z [ A ] Z = 1 N , o = { [ T ] = Z } , "\\xC6\\x99\\x10\\xA3\\x17Y\\x18\\x0D"
                                        --[[P(40655)->[314]]
                                        h = g ( U , s , N ) s , u , e = .3 , 33042669976602 , "\\xDC\\x10A"
                                        --[[P(40515)->[174]]
                                        g = R [ M [ 5 ] ] U = R [ M [ 9 ] ] I = 28135031730989 Z = R [ M [ 7 ] ] S = R [ M [ 8 ] ] A = S ( o , u ) T = Z [ A ] A = "UDim2"
                                        --[[P(40720)->[379]]
                                        S = w [ A ] o = R [ M [ 7 ] ] u = R [ M [ 8 ] ] v = u ( e , I ) A = o [ v ] o , v = 0 , 10 Z = S [ A ] u , A = 0.5 , 0.5 S = Z ( A , o , u , v ) N = { [ T ] = S } h = g ( U , s , N ) g = R [ M [ 5 ] ] u , s = 28644960089114 , 0.25 U = R [ M [ 10 ] ] o = ",PmL\\x1A\\x0E0\\xB4\\x9B\\xDC\\xBA5\\xD5N\\x15\\x15?"
                                        --[[P(41059)->[718]]
                                        Z = R [ M [ 7 ] ] S = R [ M [ 8 ] ] A = S ( o , u ) T = Z [ A ] Z = 1 N , u = { [ T ] = Z } , 20917013194252 h = g ( U , s , N ) s = .3 g = R [ M [ 5 ] ] U = R [ M [ 11 ] ] Z = R [ M [ 7 ] ] o = "O\\x10\\xD4\\xEE\\xA7\\xEEo\\x1A\\x830\\x16\\x7F\\xB2\\xA0\\xF4\\xE6\\xB9u$\\xDF\\xCEP"
                                        --[[P(40806)->[465]]
                                        S = R [ M [ 8 ] ] A = S ( o , u ) T = Z [ A ] Z = 1 N = { [ T ] = Z } h = g ( U , s , N ) g = R [ M [ 12 ] ] W = g and 10297977 or 10948612
                                    elseif W < 15160579 then
                                        Z , v , W , S = "X\\xF4\\x0E\\xF3G\\x07\\xB0\\xF7\\xC7\\xFB/\\xB2do"
                                        --[[P(40560)->[219]]
                                        , 30999619205219 , N , 5195324901747 s [ W ] = g g = R [ M [ 1 ] ] N = R [ M [ 2 ] ] T = N ( Z , S ) W = g [ T ] S = R [ M [ 1 ] ] N , u = W , "\\xBC\\xF1\\xF1\\xE9\\x91\\x07\\xA7\\x87\\xFF\\xE2\\x00\t\\xBB\\x84"
                                        --[[P(40646)->[305]]
                                        A = R [ M [ 2 ] ] o = A ( u , v ) Z = S [ o ] T = s [ Z ] W , g = T and - 5051077 or 14161867 , T
                                    else
                                        W = 13185756
                                    end
                                else
                                    if W < 14674396 then
                                        s = 32 U = R [ M [ 3 ] ] u = 2 h = U % s s = 13 Z = R [ M [ 3 ] ] T = Z - h Z = 32 N = T / Z U = s - N T = R [ M [ 4 ] ] A = R [ M [ 2 ] ] o = u ^ U e = 256 S = A / o Z = T ( S ) o , T = 1 , 4294967296 N = Z % T Z = 2 T = Z ^ h s = N / T T = R [ M [ 4 ] ] t , h = 256 , nil A = s % o o = 4294967296 S = A * o Z = T ( S ) T = R [ M [ 4 ] ] S = T ( s ) A = 65536 N = Z + S Z = 65536 T = N % Z o = 256 S = N - T s = nil Z = S / A A = T % o v = T % e U = nil u = T - v N , v = nil , 256 o = u / v v , T = 256 , nil u = Z % v I = Z % t e = Z - I I , W , Z = 256 , 10863621 , nil v = e / I S = { A , o , u , v } R [ M [ 1 ] ] = S
                                    elseif 14836796 > W then
                                        U = R [ M [ 2 ] ] h = not U g , W = h , 10402853
                                    elseif W < 14916143 then
                                        o , U = 25248191032813 , .4 W = R [ M [ 5 ] ] h = R [ M [ 7 ] ] T = R [ M [ 3 ] ] Z = R [ M [ 4 ] ] A = "&\\xAB\\x831\\x83\\xC1\\xFC\\xA6\\xCE3\\xBC\\x16eZ\\x89\\xE2"
                                        --[[P(40869)->[528]]
                                        S = Z ( A , o ) N = T [ S ] T = 0 s = { [ N ] = T } g = W ( h , U , s ) W = 11274573
                                    else
                                        g = R [ U ] A = "6S"
                                        --[[P(40476)->[135]]
                                        W = g ~= A W = W and 5729123 or 10850024
                                    end
                                end
                            else
                                if W < 14134247 then
                                    if 13792654 > W then
                                        W = v W , g = u and 12360563 or 16088627 , u
                                    elseif W < 13853814 then
                                        W , Z = 1242483 ~= 1852659 , 32493215071002 R [ M [ 1 ] ] = W g = R [ M [ 3 ] ] U = R [ M [ 4 ] ] T = "\\xDE\\x12\\xF2\\x84\\xCE\\xC1"
                                        --[[P(40372)->[31]]
                                        s = R [ M [ 5 ] ] N = s ( T , Z ) h = U [ N ] o , U , u = "\\xAB\\x80\\x8D\\xADY\\xBE\\x0B\\xCB\\x8D.\\x96N\\x1C\\xF9e\\xE5"
                                        --[[P(40791)->[450]]
                                        , 3456897 > - 18202114 , 25963902955322 g [ h ] = U s = .2 g = R [ M [ 6 ] ] U = R [ M [ 7 ] ] e = 29927350007408 Z = R [ M [ 4 ] ] S = R [ M [ 5 ] ] v = "\\x7F\\xDA\\x95T\\xEA\\x94\\xC2w{\\xCC\\xE9+\\x16!\\x15Q"
                                        --[[P(40903)->[562]]
                                        A = S ( o , u ) T = Z [ A ] Z , o , u = 1 , "^\\x17]\\x1A\\xA2\\xF2\\xD9\\xC5F\\x8D\\xFA\\xD9i\\x14\\xF1,\\x8C\\xDF=\\x19\\x87\\"
                                        --[[P(40367)->[26]]
                                        , 16285165772191 N = { [ T ] = Z } h = g ( U , s , N ) g = R [ M [ 6 ] ] U = R [ M [ 8 ] ] s = .2 Z = R [ M [ 4 ] ] S = R [ M [ 5 ] ] A = S ( o , u ) T = Z [ A ] Z = 1 N , u = { [ T ] = Z } , 15430521478161 h = g ( U , s , N ) s = .2 g = R [ M [ 6 ] ] U = R [ M [ 3 ] ] o = "u\\xE7\\xA0\\xA9W\"q\\xDD\\x18\\xD3\\x90\\xBA1\\xCEZ\\x8B\\xCD=ph\\xAF\\x0E"
                                        --[[P(40872)->[531]]
                                        Z = R [ M [ 4 ] ] I = 7710164585990 S = R [ M [ 5 ] ] A = S ( o , u ) T = Z [ A ] Z = 1 A = R [ M [ 4 ] ] o = R [ M [ 5 ] ] u = o ( v , e ) S = A [ u ] A = 1 N = { [ T ] = Z ;
                                        [ S ] = A } h = g ( U , s , N ) o , s = "\\x92\\xEB\\x16D@\\x13\\xFF\\x0C\\xD4NM\\xA4"
                                        --[[P(40934)->[593]]
                                        , .2 g = R [ M [ 6 ] ] U = R [ M [ 9 ] ] u = 33518823144696 Z = R [ M [ 4 ] ] S = R [ M [ 5 ] ] A = S ( o , u ) T = Z [ A ] Z = 1 N = { [ T ] = Z } Z = "\\x0F\\x03{\\xAE"
                                        --[[P(40912)->[571]]
                                        h = g ( U , s , N ) U = "task"
                                        --[[P(40721)->[380]]
                                        h = w [ U ] S = 33386831527098 s = R [ M [ 4 ] ] N = R [ M [ 5 ] ] T = N ( Z , S ) U = s [ T ] g = h [ U ] u , Z , U , T = 18884947632729 , 31633780865418 , .22 , "S\\xB6\\x0D\\xE4\\x8A\\x8E\\x96"
                                        --[[P(40815)->[474]]
                                        h = g ( U ) g = R [ M [ 7 ] ] U = R [ M [ 4 ] ] s = R [ M [ 5 ] ] N = s ( T , Z ) o = "\\xD9\\xD2\\xDA\\xFC"
                                        --[[P(40432)->[91]]
                                        h = U [ N ] T , Z , U = "\\x8F\\xA1\\xB9h\\xE2r\\xB8"
                                        --[[P(40884)->[543]]
                                        , 26986894373142 , 3937802 >= - 4387784 g [ h ] = U g = R [ M [ 8 ] ] U = R [ M [ 4 ] ] s = R [ M [ 5 ] ] N = s ( T , Z ) h = U [ N ] U = 3233533 >= - 8641914 g [ h ] = U e , T = "_\\x84\\x08x\\xABn[\\xF6i$"
                                        --[[P(40618)->[277]]
                                        , "\\xF5\\xB1\\xCA|e^,"
                                        --[[P(41076)->[735]]
                                        g = R [ M [ 3 ] ] U = R [ M [ 4 ] ] Z = 11736423978329 s = R [ M [ 5 ] ] N = s ( T , Z ) p = 33418831772873 h = U [ N ] U = 789633 >= 5148967 g [ h ] = U g = R [ M [ 6 ] ] U = R [ M [ 10 ] ] s = .48 Z = R [ M [ 4 ] ] S = R [ M [ 5 ] ] A = S ( o , u ) T = Z [ A ] A = "UDim2"
                                        --[[P(40720)->[379]]
                                        S = w [ A ] o = R [ M [ 4 ] ] u = R [ M [ 5 ] ] v = u ( e , I ) A = o [ v ] Z = S [ A ] o , e , A , v = 150 , 16802340200080 , 330 , "\\x06\\xEE~X\\xE6/\\x9D\\xD7"
                                        --[[P(40392)->[51]]
                                        S = Z ( A , o ) t = "\\xB9J\\xC8s\\x90'\\xE51\\x16"
                                        --[[P(40427)->[86]]
                                        A = R [ M [ 4 ] ] o = R [ M [ 5 ] ] u = o ( v , e ) Z = A [ u ] u = "UDim2"
                                        --[[P(40720)->[379]]
                                        o = w [ u ] v = R [ M [ 4 ] ] e = R [ M [ 5 ] ] I = e ( t , p ) u = v [ I ] I , v = 16401849359829 , 0.5 A = o [ u ] u = 0.5 o = A ( u , v ) N , e , A = { [ T ] = S ;
                                        [ Z ] = o } , "\\xF1/VU-|\\xB5\\xEAa\\x9E-"
                                        --[[P(41006)->[665]]
                                        , "Enum"
                                        --[[P(41057)->[716]]
                                        S = w [ A ] o = R [ M [ 4 ] ] u = R [ M [ 5 ] ] v = u ( e , I ) t , e = 34033031396839 , 31114166696088 A = o [ v ] Z = S [ A ] v = "\\x87\\x18k\\xEA\\xB0"
                                        --[[P(40504)->[163]]
                                        A = R [ M [ 4 ] ] o = R [ M [ 5 ] ] u = o ( v , e ) S = A [ u ] o = "Enum"
                                        --[[P(41057)->[716]]
                                        T = Z [ S ] A = w [ o ] u = R [ M [ 4 ] ] v = R [ M [ 5 ] ] I = "[\\xBCy\\x8F\\xD5\\x08\\xEA\\x99Z\\xB3\\x82\n@\\xBB\\xDC"
                                        --[[P(40524)->[183]]
                                        e = v ( I , t ) o = u [ e ] S = A [ o ] I = 6465668287426 o = R [ M [ 4 ] ] u = R [ M [ 5 ] ] e = "\\\\xF0f\\xF1\\xE5"
                                        --[[P(40994)->[653]]
                                        v = u ( e , I ) A = o [ v ] Z = S [ A ] u = 16115814128976 h = g ( U , s , N , T , Z ) g = R [ M [ 6 ] ] s = .48 U = R [ M [ 11 ] ] Z = R [ M [ 4 ] ] S = R [ M [ 5 ] ] o = "\\xEF\\xA4\\xA4\\xCB\\xA5"
                                        --[[P(40828)->[487]]
                                        A = S ( o , u ) T = Z [ A ] Z = R [ M [ 12 ] ] S = Z ( ) A , I , N = "Enum"
                                        --[[P(41057)->[716]]
                                        , 27451689497071 , { [ T ] = S } S = w [ A ] o = R [ M [ 4 ] ] u = R [ M [ 5 ] ] e = "Z\\x94\\xAE\\x82\\xF9[@\\x1F_R\\xBD"
                                        --[[P(40658)->[317]]
                                        v = u ( e , I ) A = o [ v ] Z = S [ A ] v , e = "\\x80\\xFB\\xF3\\xB5"
                                        --[[P(40960)->[619]]
                                        , 26966977442061 A = R [ M [ 4 ] ] o = R [ M [ 5 ] ] t , p = 31834169244135 , 14157444536768 u = o ( v , e ) I = "\\xB1\\x90B\\xEA\\xE5\\xC4\\xDA*\"\\x14\\x91\\xE6\\xE2\\x06\\xD1"
                                        --[[P(40634)->[293]]
                                        S = A [ u ] T = Z [ S ] o = "Enum"
                                        --[[P(41057)->[716]]
                                        A = w [ o ] u = R [ M [ 4 ] ] v = R [ M [ 5 ] ] e = v ( I , t ) o = u [ e ] S = A [ o ] o = R [ M [ 4 ] ] e , I = "\\x1A\\x0F+"
                                        --[[P(40426)->[85]]
                                        , 9062979309692 u = R [ M [ 5 ] ] v = u ( e , I ) A = o [ v ] e = "LP^~\\x0D\\xF3\\xD3m\\xCB\\x07"
                                        --[[P(40479)->[138]]
                                        Z = S [ A ] o = "3\\x1F\\x99\\xA6\\x0F%\\xAB\\xBF"
                                        --[[P(40509)->[168]]
                                        h = g ( U , s , N , T , Z ) g = R [ M [ 6 ] ] u , I , s = 26796855636158 , 33900309708202 , .48 U = R [ M [ 13 ] ] Z = R [ M [ 4 ] ] S = R [ M [ 5 ] ] A = S ( o , u ) T = Z [ A ] A = "UDim2"
                                        --[[P(40720)->[379]]
                                        S = w [ A ] o = R [ M [ 4 ] ] u = R [ M [ 5 ] ] v = u ( e , I ) e = 11675785909564 A = o [ v ] o = - 21 Z = S [ A ] A , t = - 21 , "Jq\\x15"
                                        --[[P(40824)->[483]]
                                        S = Z ( A , o ) v = "\\xFB\\xBB\\xB3\\x00"
                                        --[[P(40423)->[82]]
                                        A = R [ M [ 4 ] ] o = R [ M [ 5 ] ] u = o ( v , e ) Z = A [ u ] u = "UDim2"
                                        --[[P(40720)->[379]]
                                        o = w [ u ] v = R [ M [ 4 ] ] e = R [ M [ 5 ] ] I = e ( t , p ) e = 1 u = v [ I ] A = o [ u ] v , u , I = 42 , 1 , 42 o = A ( u , v , e , I ) N , I , A = { [ T ] = S ;
                                        [ Z ] = o } , 19730850931683 , "Enum"
                                        --[[P(41057)->[716]]
                                        S = w [ A ] e , t = "\\x02\\xE9,\\xD9\\xEBH/\\x8F\\xDD\\xAD@"
                                        --[[P(40844)->[503]]
                                        , 21890541529041 o = R [ M [ 4 ] ] u = R [ M [ 5 ] ] v = u ( e , I ) A = o [ v ] I = "\\xC2\\xC8\\xCC\\xFA\\xF3\\xE1\\x0D\\x9D\\x9D\\xDD\\xDE\\xF4\\xB93\\xD3"
                                        --[[P(40770)->[429]]
                                        Z = S [ A ] A = R [ M [ 4 ] ] v , e = "\\xCD\\xF7m4\\xDF"
                                        --[[P(40544)->[203]]
                                        , 19507910468476 o = R [ M [ 5 ] ] u = o ( v , e ) o = "Enum"
                                        --[[P(41057)->[716]]
                                        S = A [ u ] T = Z [ S ] A = w [ o ] u = R [ M [ 4 ] ] v = R [ M [ 5 ] ] e = v ( I , t ) o = u [ e ] S = A [ o ] I = 6721188564025 o = R [ M [ 4 ] ] e = "\\xF0\\xDD\\xC7\\x98\\xFE"
                                        --[[P(40406)->[65]]
                                        u = R [ M [ 5 ] ] v = u ( e , I ) A = o [ v ] Z = S [ A ] h = g ( U , s , N , T , Z ) U = "task"
                                        --[[P(40721)->[380]]
                                        h = w [ U ] Z = "\\xA1\\xC41\\xDE"
                                        --[[P(40898)->[557]]
                                        s = R [ M [ 4 ] ] S = 16816753434262 N = R [ M [ 5 ] ] T = N ( Z , S ) U = s [ T ] g = h [ U ] S , U = 32247274912424 , 0.5 h = g ( U ) Z = 12670072379147 g = R [ M [ 14 ] ] T = "\\x8Cn\\x12e\"\\xD9\\xC4"
                                        --[[P(40546)->[205]]
                                        U = R [ M [ 4 ] ] s = R [ M [ 5 ] ] N = s ( T , Z ) h = U [ N ] U , T = 14897573 ~= 888804 , "\n\\x9F\\x17\\xB1u1\\x87"
                                        --[[P(40847)->[506]]
                                        g [ h ] = U g = R [ M [ 15 ] ] Z = 23006354336217 U = R [ M [ 4 ] ] s = R [ M [ 5 ] ] N = s ( T , Z ) h = U [ N ] U = 14715278 > 9759008 g [ h ] = U Z = "a|\\xEC\\x19ve+59}\\x96\\xEF\\xE3w\\x90\\x0C\\xDE\\x1D\\x90\\xDB^"
                                        --[[P(40795)->[454]]
                                        g = R [ M [ 16 ] ] s = R [ M [ 4 ] ] N = R [ M [ 5 ] ] T = N ( Z , S ) U = s [ T ] h = g ( U ) s = .9 g = R [ M [ 17 ] ] U = .34 h = g ( U , s ) h = "pcall"
                                        --[[P(40547)->[206]]
                                        g = w [ h ] s = z ( 13150106 , { M [ 18 ] } ) N = { g ( s ) } U = N [ 2 ] s = f ( ) h = N [ 1 ] N = not h R [ s ] = U U , g = W , N W = N and - 1528377 or 1578277
                                    elseif 14006136 > W then
                                        t = "Enum"
                                        --[[P(41057)->[716]]
                                        I = w [ t ] p = R [ M [ 2 ] ] K = 15484801457194 C = R [ M [ 3 ] ] j = "&\\x98\\xD3\\xD9\\x08,>\\xA6;\\x84\\x1F\\x9C\\x0C\\xD7_"
                                        --[[P(40471)->[130]]
                                        D = C ( j , K ) j = 30964894578771 t = p [ D ] e = I [ t ] t = R [ M [ 2 ] ] D , W = "\\x8FI\\xEF"
                                        --[[P(40679)->[338]]
                                        , 3740949 p = R [ M [ 3 ] ] C = p ( D , j ) I = t [ C ] v = e [ I ] o = v
                                    else
                                        g = "Cancel"
                                        --[[P(40801)->[460]]
                                        W = R [ M [ 1 ] ] g = W [ g ] g = g ( W ) W , g = w [ "53joyJrifjEJZL"
                                        --[[P(40951)->[610]]
                                        ] , { }
                                    end
                                else
                                    if 14160026 > W then
                                        W = R [ M [ 1 ] ] g = "Destroy"
                                        --[[P(40466)->[125]]
                                        g = W [ g ] g = g ( W ) W = 9731597
                                    elseif W < 14171597 then
                                        A , W , I = "Enum"
                                        --[[P(41057)->[716]]
                                        , 3949945 , 22556018239751 S = w [ A ] e = "\\xDE\\xF4\\x1E*\\x14L\\x07\\x11\\xF6)\\x1F9\\xE6\\xC4"
                                        --[[P(40691)->[350]]
                                        o = R [ M [ 1 ] ] u = R [ M [ 2 ] ] v = u ( e , I ) A = o [ v ] Z = S [ A ] e , v = 15198009793445 , "\\x9A\\x98 }"
                                        --[[P(40371)->[30]]
                                        A = R [ M [ 1 ] ] o = R [ M [ 2 ] ] u = o ( v , e ) S = A [ u ] T = Z [ S ] g = T
                                    elseif W < 14365243 then
                                        W = { } h = W W = 11617609 s = R [ M [ 9 ] ] U , N = 1 , s s = 1 T = s s = 0 Z = T < s s = U - T
                                    else
                                        D = O ( 791592 , { N } ) j = { D ( ) } W , g = w [ "PHwXSoodV1ZsH"
                                        --[[P(40411)->[70]]
                                        ] , { b ( j ) }
                                    end
                                end
                            end
                        else
                            if 16492744 > W then
                                if 15955454 > W then
                                    if 15546484 > W then
                                        Z , o = S ( T , Z ) W = Z and 1665727 or 4439651
                                    elseif W < 15638169 then
                                        W = 13798017 >= - 9755143 W = W and 8842850 or - 3328762
                                    elseif 15765807 > W then
                                        W , d = 13060438 , "l2"
                                        --[[P(40709)->[368]]
                                        D = w [ d ] d = "l1"
                                        --[[P(40370)->[29]]
                                        w [ d ] = D
                                    else
                                        N , e , k , U , s = n [ 4 ] , 8142647185103 , 33225239264367 , n [ 2 ] , n [ 3 ] W = R [ M [ 1 ] ] h , u , v , d , o , G , J , D = n [ 1 ] , 11567813825802 , "6\\xF0F\\x1D"
                                        --[[P(40381)->[40]]
                                        , 9853102395884 , "\\xB2\\x17\\x00\\x05\\xEF6\\x98\\x1AO\\x8D"
                                        --[[P(40395)->[54]]
                                        , "\\xD6o\\xD5\\xFC"
                                        --[[P(40407)->[66]]
                                        , "N\\xCCN#S\\x0D"
                                        --[[P(41060)->[719]]
                                        , 7869210463824 Z = R [ M [ 2 ] ] t , x = 22274247616644 , 3985705191231 S = R [ M [ 3 ] ] A = S ( o , u ) T = Z [ A ] A = R [ M [ 2 ] ] o = R [ M [ 3 ] ] u = o ( v , e ) j , e , I , K = 34180410998316 , "p)\\xDEm\t}\\x0C\\xA6=\\xD7"
                                        --[[P(40985)->[644]]
                                        , 2609307157695 , "\\xBC\\xAD\\xA7\\xAD\\xB8"
                                        --[[P(40639)->[298]]
                                        S = A [ u ] o = R [ M [ 2 ] ] u = R [ M [ 3 ] ] v = u ( e , I ) I , C = "\\xE34-\\xDDI\\xFA~2\\xB5\\xB6\\x1A"
                                        --[[P(40748)->[407]]
                                        , "\n\\xF2\\xCC"
                                        --[[P(40957)->[616]]
                                        A = o [ v ] u = R [ M [ 2 ] ] v = R [ M [ 3 ] ] e = v ( I , t ) o = u [ e ] e = "Vector2"
                                        --[[P(40861)->[520]]
                                        v = w [ e ] I = R [ M [ 2 ] ] t = R [ M [ 3 ] ] p = t ( C , D ) e = I [ p ] I , C = 0.5 , 22909673466284 u = v [ e ] H , p , e = 19214427595507 , "\\xEE\\xAA\\xE9\\x87\\xAE=\\xEF\\xFA"
                                        --[[P(40799)->[458]]
                                        , 0.5 v = u ( e , I ) e = R [ M [ 2 ] ] I = R [ M [ 3 ] ] t = I ( p , C ) u = e [ t ] E = "\\xB7\\xDA\\x1CK+U"
                                        --[[P(40931)->[590]]
                                        I = R [ M [ 2 ] ] C , D = "\\x95\\x8F\\xBB\\x9A"
                                        --[[P(40906)->[565]]
                                        , 17968165232815 t = R [ M [ 3 ] ] p = t ( C , D ) e = I [ p ] t = R [ M [ 2 ] ] D = "\\xC4\\xD8\\xE4\\xA7~=xcK\\xBFn\\xFFC\\xA4\\xDE`\\xA5\\xB7\\x9B\\xFE`,"
                                        --[[P(40533)->[192]]
                                        p = R [ M [ 3 ] ] C = p ( D , j ) I = t [ C ] C = R [ M [ 2 ] ] t = 1 D = R [ M [ 3 ] ] j = D ( K , d ) p = C [ j ] D = R [ M [ 4 ] ] K = R [ M [ 2 ] ] d = R [ M [ 3 ] ] r = d ( G , H ) j = K [ r ] C = D [ j ] r = "\\xE0%\\\\x04\\x08\\xF6\\x97\\xC5\\xB7\\xBD\\x10"
                                        --[[P(40593)->[252]]
                                        j = R [ M [ 2 ] ] K = R [ M [ 3 ] ] G = 25307013213704 d = K ( r , G ) D = j [ d ] K = R [ M [ 5 ] ] r = R [ M [ 2 ] ] G = R [ M [ 3 ] ] H = G ( E , x ) d = r [ H ] j = K [ d ] d = R [ M [ 2 ] ] E = 16588848406060 r = R [ M [ 3 ] ] H , x = "=\n2;\\x08U\\x9A\\xE6<D`\\xE0\\x04IMi\\xA8"
                                        --[[P(41086)->[745]]
                                        , 20848144983532 G = r ( H , E ) K = d [ G ] r = R [ M [ 2 ] ] E = "\\xE7\\xC0A\\xEE\\x06;~\\x17"
                                        --[[P(40577)->[236]]
                                        G = R [ M [ 3 ] ] H = G ( E , x ) d = r [ H ] G , H = W , 90 r = N or H H = R [ M [ 2 ] ] E = R [ M [ 3 ] ] x = E ( J , k ) G = H [ x ] H = 1 Z = { [ S ] = A ;
                                        [ o ] = v ;
                                        [ u ] = U ;
                                        [ e ] = h , [ I ] = t , [ p ] = C , [ D ] = j , [ K ] = s , [ d ] = r ;
                                        [ G ] = H } S = R [ M [ 6 ] ] g = W ( T , Z , S ) W , T = w [ "lXR2BYFSIa69"
                                        --[[P(40480)->[139]]
                                        ] , g g = { T }
                                    end
                                else
                                    if 16118777 > W then
                                        v , W = "unpack"
                                        --[[P(40797)->[456]]
                                        , 12360563 u = w [ v ] g = u
                                    elseif 16192071 > W then
                                        W = I C = R [ N ] E = 35146531930094 r = R [ U ] H = "\\xCF\\xA7\\x0E\\xC7\\x16\\xDFg\\xC2"
                                        --[[P(40986)->[645]]
                                        G = r ( H , E ) t = C [ G ] C , I = 10 , "WaitForChild"
                                        --[[P(40461)->[120]]
                                        I = e [ I ] I = I ( e , t , C ) t = not I W = t and 6450991 or - 9029333
                                    elseif 16347742 > W then
                                        W = R [ M [ 5 ] ] h = R [ M [ 6 ] ] g = W ( h ) R [ M [ 7 ] ] = g W = R [ M [ 5 ] ] U = R [ M [ 6 ] ] h = W ( U ) W = 3022186 R [ M [ 8 ] ] = h
                                    else
                                        h = nil R [ M [ 5 ] ] = g W = 13044370
                                    end
                                end
                            else
                                if W < 16661505 then
                                    if 16539176 > W then
                                        h , s , Z = "type"
                                        --[[P(40581)->[240]]
                                        , "gethui"
                                        --[[P(40604)->[263]]
                                        , 14654336031399 g = w [ h ] U = w [ s ] h = g ( U ) U = R [ M [ 1 ] ] s = R [ M [ 2 ] ] T = "\t\\xD4\\x1A\\x87\\x15\n\\xFCr"
                                        --[[P(41054)->[713]]
                                        N = s ( T , Z ) g = U [ N ] W = h == g W = W and 6537521 or - 14507879
                                    elseif 16567453 > W then
                                        W = 3022186
                                    elseif W < 16596988 then
                                        h = R [ M [ 1 ] ] g , W = h , h and 692497 or 13396177
                                    else
                                        W = R [ M [ 1 ] ] g = "Destroy"
                                        --[[P(40466)->[125]]
                                        g = W [ g ] g = g ( W ) g , W = { } , w [ "KJ1M4ilP1qJsOm"
                                        --[[P(40657)->[316]]
                                        ]
                                    end
                                else
                                    if W < 16726981 then
                                        W , o = 6102334 , { } S = o
                                    elseif 16753821 > W then
                                        W , N = 15522610 > - 7940402 , "string"
                                        --[[P(40888)->[547]]
                                        R [ U ] = W s = w [ N ] Z , N = W , "gmatch"
                                        --[[P(40580)->[239]]
                                        g = s [ N ] s = f ( ) A = "pcall"
                                        --[[P(40547)->[206]]
                                        R [ s ] = g N = f ( ) g = a ( 4311225 , { } ) R [ N ] = g g = 5153430 >= 11406893 T = f ( ) o = O ( 10823552 , { T } ) R [ T ] = g S = w [ A ] A = S ( o ) W , g = A and 14928581 or 10257773 , A
                                    else
                                        T , Z = "\\xF7\\xB6p\\xA7~\\xDD&"
                                        --[[P(40746)->[405]]
                                        , 13876307401021 g = R [ M [ 1 ] ] U = R [ M [ 2 ] ] s = R [ M [ 3 ] ] N = s ( T , Z ) h = U [ N ] W = g [ h ] W = W and 867133 or 12685973
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        W = # X return b ( g )
    end , function ( w , P )
        local b = s ( P ) local n = function ( )
            return W ( w , { } , P , b )
        end
        return n
    end , function ( w )
        h [ w ] = h [ w ] - 1 if 0 == h [ w ] then
            h [ w ] , R [ w ] = nil , nil
        end
    end , function ( w , P )
        local b = s ( P ) local n = function ( n , M , X , Y , g , R , h , f , U , s )
            return W ( w , { n ;
            M ;
            X , Y ;
            g ;
            R , h ;
            f , U , s } , P , b )
        end
        return n
    end , 0 , { } , function ( w , P )
        local b = s ( P ) local n = function ( n , M , X )
            return W ( w , { n , M ;
            X } , P , b )
        end
        return n
    end , function ( w , P )
        local b = s ( P ) local n = function ( n , M , X , Y , g , R , h , f )
            return W ( w , { n , M ;
            X , Y ;
            g ;
            R , h , f } , P , b )
        end
        return n
    end , function ( w )
        local P , W = 1 , w [ 1 ] while W do
            h [ W ] , P = h [ W ] - 1 , P + 1 if - 774302 == h [ W ] then
                h [ W ] , R [ W ] = nil , nil
            end
            W = w [ P ]
        end
    end , function ( )
        U = U + 1 h [ U ] = 1 return U
    end
    return ( T ( 13655038 , { } ) ) ( b ( g ) )
end ) ( select , newproxy , unpack or table [ "unpack"
--[[P(40797)->[456]]
] , { ... } , getmetatable , setmetatable , getfenv and getfenv ( ) or _ENV )
end ) ( ... )
