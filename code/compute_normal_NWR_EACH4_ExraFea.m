function [normal_one noncompute max_sort , feature_id , feature_normal] = compute_normal_NWR_EACH4_ExraFea(points , local_W , ran_num ,  inner_threshold , Par , des , T)

num = size(points , 1) ;
NonInner = true(1 , num) ;
computedNum = 0;

feature_normal = [] ;
noncompute = 0 ;
max_sort = 0;
normal_one = zeros(1 , 3) ;

 while computedNum==0 || sum(des(NonInner)) > (sum(des)* ((1/(computedNum+1)) - Par.compart*(computedNum+1)))
    computedNum = computedNum + 1 ;
    
    curPoints = points(NonInner , :) ;
    curLocal_W = local_W(NonInner , NonInner) ;
    if computedNum == 1
        [curNormal curNonCompute curSort dis_vect] = compute_normal_NWR_EACH5_ExraFea(curPoints , curLocal_W , ran_num , inner_threshold) ;
        normal_one = curNormal ;
        noncompute = curNonCompute ;
        max_sort = curSort ;
        feature_normal = [feature_normal ; curNormal] ;
    end
    if computedNum > 1
        [curNormal curNonCompute curSort dis_vect center] = compute_normal_NWR_EACH6_ExraFea(curPoints , curLocal_W , ran_num , inner_threshold) ;
    end
    
    if curNonCompute == 1
        break ;
    end
    NonInnerFlag = (NonInner == 1) ;
    NewNonInner = dis_vect > inner_threshold.^2 ;
    if computedNum > 1
        dis1 = ((points(1 , :) - center)*curNormal').^2 ;
        if dis1 < T * (inner_threshold).^2  && (max(curNormal * feature_normal')) < cos((10/180)*pi) ;
            feature_normal = [feature_normal ; curNormal] ;
        end
    end
    
    if computedNum > 5
        break
    end
    
    NonInner(NonInnerFlag) = NewNonInner ;
    
    if sum(NonInner) < 3
        break;
    end
end

feature_id = 0 ;
if size(feature_normal , 1)  > 1
    feature_id = 1 ;
end
