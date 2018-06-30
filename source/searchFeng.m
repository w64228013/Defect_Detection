function [ linearindex ] = searchFeng( image )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

[Image_Row,Image_Col] = size(image);

image = int16(image);

increase = 1;
decrease = 2;
horizontal = 3;

new_image = zeros(Image_Row,Image_Col);
for x = 1:Image_Row
    row_data = (image(x,1:Image_Col));
%     row_data = round(smooth(double(row_data),4));
    for y = 1:(Image_Row-1) %最后一个像素不检测
        deta = row_data(y+1) - row_data(y);
        if(deta>0) % 大于0 说明上坡            
            if(deta < 8) %差值小于8 
                new_image(x,y) = increase;
                continue;
            end
        end
        if(deta<0) % 小于0 说明下坡
           if(abs(deta) < 8)
               new_image(x,y) = decrease;
               continue;
           end            
        end
        if(deta == 0) %说明平坡
           new_image(x,y) = horizontal;
           continue;
        end
    end
end
startpoint_mode = 1;
overpoint_mode = 2;
nextstart_mode = 3;
search_mode = startpoint_mode;
aim_is_feng = 0;

for x = 1:Image_Row
    start_point = 0;
    over_point = 0;
    next_start_point = 0;
    horizontal_NO = 0;
    search_mode = startpoint_mode;
    for y = 10:(Image_Col-10) % 前10个像素和最后10个像素不统计      
        switch search_mode
            case startpoint_mode
               if(new_image(x,y) == increase)
                    start_point = y;
                    search_mode = overpoint_mode;
               end
            case overpoint_mode
                if(new_image(x,y) == decrease)
                    over_point = y;
                    search_mode = nextstart_mode;
                end               
            case nextstart_mode 
%                    if( x == 206 )
%                     over_sign = 0;
%                    end
                if new_image(x,y) == increase
                   next_start_point = y; 
                   %如果是山峰，那么就全部标记为10                   
                     [IsFeng,realStartP,realNextP] = ...
                         CheckIsFeng(image,x,start_point,over_point,next_start_point);
                   if( IsFeng == 1)
                        new_image(x,realStartP:realNextP-1) = 10;
                   end
                   start_point = next_start_point;
                   search_mode = overpoint_mode;
                elseif new_image(x,y) == horizontal
                    horizontal_NO = horizontal_NO + 1;
                    if horizontal_NO > 1
                       if abs((image(x,y)) - (image(x,start_point))) < 5
                           next_start_point = y;
                           [IsFeng,realStartP,realNextP] = ...
                                 CheckIsFeng(image,x,start_point,over_point,next_start_point);
                           if( IsFeng == 1)
                                new_image(x,realStartP:realNextP-1) = 10;
                           end
                           search_mode = startpoint_mode;
                           horizontal_NO = 0;
                       else
                           horizontal_NO = 0;
                       end
                    end
                else
                    horizontal_NO = 0; % 清零，因为需要连续的才计数
                end
            otherwise
                break;    
        end        
    end    
end

linearindex = find(new_image == 10);
end

function [IsFeng,realStartP,realNextP]  = CheckIsFeng(image,row,startP,overP,nextP)

    width_high_thresold = 24;
    width_low_thresold = 5; 
    shape_high_thresold = 25;
    shape_low_thresold = 5;
    height_high_thresold = 25;
    height_low_thresold = 6;
    foot_deta_thresold = 5;
    
    length_thresold = 8;
    
    image = int16(image);

    IsFeng = 0;     
    
%   这部分是解决山峰起点和终点间隔过长，从而忽略了一些正确的山峰，如果距离过大，那么进行修正
    peakP = overP;
    leftLength = peakP - startP;
    rightLength = nextP - peakP;
    
    if abs(rightLength - leftLength) > length_thresold
        if leftLength < rightLength
            nextP = peakP + leftLength;
        else 
            startP = peakP - rightLength;
        end
    end

    realStartP = startP;
    realNextP = nextP;
    
    aim_width = nextP - startP;
    foot_deta = image(row,startP) - image(row,nextP);
    aim_height = image(row,overP) - image(row,startP);
    aim_shape = image(row,overP) - ...
       (image(row,startP) + image(row,nextP))/2;

    if(aim_width >width_high_thresold || aim_width < width_low_thresold) 
        return;
    end
    if( abs(foot_deta) > foot_deta_thresold)
        return;
    end
    if(aim_height > height_high_thresold || aim_height < height_low_thresold)
        return;
    end
    if(aim_shape > shape_high_thresold || aim_shape < shape_low_thresold )
        return;
    end
    
    IsFeng = 1;
end

