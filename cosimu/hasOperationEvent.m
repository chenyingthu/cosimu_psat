function [ResultData, hasOptEvent, opts ] = hasOperationEvent(Config, ResultData, t)
hasOptEvent = 0;
opts = [];

[r, c] = size(ResultData.ctrlQueue);

while c > 0
    
    if (ResultData.ctrlQueue(c).status ~= 2)
        break;
    end
    
    if abs(ResultData.ctrlQueue(c).t - t) < Config.ctrlTGap
        opts = [opts, ResultData.ctrlQueue(c)];
        hasOptEvent = 1;
        ResultData.ctrlQueue(c).status = 3;
    end

    c = c - 1;
end

end
