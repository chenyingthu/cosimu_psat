function fm_call(flag)


%FM_CALL calls component equations
%
%FM_CALL(CASE)
%  CASE '1'  algebraic equations
%  CASE 'pq' load algebraic equations
%  CASE '3'  differential equations
%  CASE '1r' algebraic equations for Rosenbrock method
%  CASE '4'  state Jacobians
%  CASE '0'  initialization
%  CASE 'l'  full set of equations and Jacobians
%  CASE 'kg' as "L" option but for distributed slack bus
%  CASE 'n'  algebraic equations and Jacobians
%  CASE 'i'  set initial point
%  CASE '5'  non-windup limits
%
%see also FM_WCALL

fm_var

switch flag


 case 'gen'

  Line = gcall(Line);
  PQ = gcall(PQ);

 case 'load'

  PQ = gcall(PQ);
  gisland(Bus)

 case 'gen0'

  Line = gcall(Line);
  PQ = gcall(PQ);

 case 'load0'

  PQ = gcall(PQ);
  gisland(Bus)

 case '3'

  fcall(Syn)
  Exc = fcall(Exc);
  Tg = fcall(Tg);
  if ~isempty(Pss.con)
      Pss = fcall(Pss);
  end

 case '1r'

  Line = gcall(Line);
  PQ = gcall(PQ);
  Syn = gcall(Syn);
  gcall(Exc)
  gcall(Tg)
  if ~isempty(Pss.con)
      gcall(Pss)
  end
  PV = gcall(PV);
  SW = gcall(SW);
  gisland(Bus)

 case 'series'

  Line = gcall(Line);
  gisland(Bus)

 case '4'

  DAE.Fx = sparse(DAE.n,DAE.n);
  DAE.Fy = sparse(DAE.n,DAE.m);
  DAE.Gx = sparse(DAE.m,DAE.n);
  Fxcall(Syn)
  Fxcall(Exc)
  Fxcall(Tg)
  if ~isempty(Pss.con)
      Fxcall(Pss)
  end

 case '0'

  Syn = setx0(Syn);
  Exc = setx0(Exc);
  Tg = setx0(Tg);
  if ~isempty(Pss.con)
      Pss = setx0(Pss);
  end

 case 'fdpf'

  Line = gcall(Line);
  PQ = gcall(PQ);
  PV = gcall(PV);
  SW = gcall(SW);
  gisland(Bus)

 case 'l'

  Line = gcall(Line);
  PQ = gcall(PQ);
  PV = gcall(PV);
  SW = gcall(SW);
  gisland(Bus)
  Gycall(Line)
  Gycall(PQ)
  Gycall(PV)
  Gycall(SW)
  Gyisland(Bus)


  
  DAE.Fx = sparse(DAE.n,DAE.n);
  DAE.Fy = sparse(DAE.n,DAE.m);
  DAE.Gx = sparse(DAE.m,DAE.n);
  Fxcall(PV)
  Fxcall(SW)

 case 'kg'

  Line = gcall(Line);
  PQ = gcall(PQ);
  Syn = gcall(Syn);
  gcall(Exc)
  gcall(Tg)
  if ~isempty(Pss.con)
      gcall(Pss)
  end
  gisland(Bus)
  Gycall(Line)
  Gycall(PQ)
  Syn = Gycall(Syn);
  Gycall(Exc)
  Gycall(Tg)
  Gyisland(Bus)


  fcall(Syn)
  Exc = fcall(Exc);
  Tg = fcall(Tg);

  DAE.Fx = sparse(DAE.n,DAE.n);
  DAE.Fy = sparse(DAE.n,DAE.m);
  DAE.Gx = sparse(DAE.m,DAE.n);
  Fxcall(Syn)
  Fxcall(Exc)
  Fxcall(Tg)

 case 'kgpf'

  global PV SW
  Line = gcall(Line);
  PQ = gcall(PQ);
  PV = gcall(PV);
  greactive(SW)
  glambda(SW,1,DAE.kg)
  gisland(Bus)
  Gycall(Line)
  Gycall(PQ)
  Gycall(PV)
  Gyreactive(SW)
  Gyisland(Bus)


  
  DAE.Fx = sparse(DAE.n,DAE.n);
  DAE.Fy = sparse(DAE.n,DAE.m);
  DAE.Gx = sparse(DAE.m,DAE.n);
  
 case 'n'

  Line = gcall(Line);
  PQ = gcall(PQ);
  Syn = gcall(Syn);
  gcall(Exc)
  gcall(Tg)
  if ~isempty(Pss.con)
      gcall(Pss)
  end
  PV = gcall(PV);
  SW = gcall(SW);
  gisland(Bus)
  Gycall(Line)
  Gycall(PQ)
  Syn = Gycall(Syn);
  Gycall(Exc)
  Gycall(Tg)
  Gycall(PV)
  Gycall(SW)
  Gyisland(Bus)


 case 'i'

  Line = gcall(Line);
  PQ = gcall(PQ);
  Syn = gcall(Syn);
  gcall(Exc)
  gcall(Tg)
  if ~isempty(Pss.con)
      gcall(Pss)
  end
  PV = gcall(PV);
  SW = gcall(SW);
  gisland(Bus)
  Gycall(Line)
  Gycall(PQ)
  Syn = Gycall(Syn);
  Gycall(Exc)
  Gycall(Tg)
  Gycall(PV)
  Gycall(SW)
  if ~isempty(Pss.con)
      Gycall(Pss)
  end
  Gyisland(Bus)


  fcall(Syn)
  Exc = fcall(Exc);
  Tg = fcall(Tg);

  if DAE.n > 0
  DAE.Fx = sparse(DAE.n,DAE.n);
  DAE.Fy = sparse(DAE.n,DAE.m);
  DAE.Gx = sparse(DAE.m,DAE.n);
  end 

  Fxcall(Syn)
  Fxcall(Exc)
  Fxcall(Tg)
  if ~isempty(Pss.con)
      Fxcall(Pss)
  end
  Fxcall(PV)
  Fxcall(SW)

 case '5'

  windup(Exc)
  if ~isempty(Pss.con)
      windup(Pss)
  end
end
