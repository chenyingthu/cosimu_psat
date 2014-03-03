function  [ResultData] = addNetLag2CtrlOperationQueue(ResultData, Config)



[r, c] = size(ResultData.ctrlQueue);

while c > 0
    
    if (ResultData.ctrlQueue(c).status ~= 1)
        break;
    end
    if Config.ctrlLagSchema == 1
        ResultData.ctrlQueue(c).t = 0  + ResultData.ctrlQueue(c).t;
    else
        ResultData.ctrlQueue(c).t = Config.ctrlAllLatency  + ResultData.ctrlQueue(c).t;
    end
    ResultData.ctrlQueue(c).status = 2; % sent ;
    c = c - 1;
end

end