function output = synsat(a,flag,e1q,isx)

b = [0.8*ones(length(isx),1), 1-a.con(isx,25), 1.2*(1-a.con(isx,26))];
c2 = b*[12.5; -25; 12.5];
c1 = b*[-27.5; 50; -22.5];
c0 = b*[15; -24; 10];

switch flag

 case 1 % saturation function
  output = e1q;
  idx = find(output > 0.8);
  if ~isempty(idx)
    output(idx)=c2(idx).*e1q(idx).^2+c1(idx).*e1q(idx)+c0(idx);
  end

 case 2 % Jacobian
  output = ones(length(isx),1);
  idx = find(e1q > 0.8);
  if ~isempty(idx)
    output(idx)=2*c2(idx).*e1q(idx) + c1(idx);
  end

end
