function n = getnum(a)

if a.n
  n = sum(~a.con(:,11).*a.u);
else
  n = 0;
end
