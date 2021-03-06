function b = subsref(a,index)

switch index(1).type
 case '.'
  switch index(1).subs
   case 'con'
    if length(index) == 2
      b = a.con(index(2).subs{:});
    else
      b = a.con;
    end
   case 'u'
    if length(index) == 2
      b = a.u(index(2).subs{:});
    else
      b = a.u;
    end
   case 'bus'
    b = a.bus;
   case 'n'
    b = a.n;
   case 'Be'
    b = a.Be;
   case 'bcv'
    b = a.bcv;
   case 'vref'
    if length(index) == 2
      b = a.vref(index(2).subs{:});
    else
      b = a.vref;
    end
   case 'q'
    if length(index) == 2
      b = a.q(index(2).subs{:});
    else
      b = a.q;
    end
   case 'vm'
    b = a.vm;
   case 'alpha'
    b = a.alpha;
   case 'ncol'
    b = a.ncol;
   case 'format'
    b = a.format;
  end
end
