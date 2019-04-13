function fitting_threshold = fitting_threshold_selection(errs,feature)

feature_errs = errs(feature);
errs(feature) = [];
number = 50;
fitting_threshold = 0;

for i = 1:number
    num1 = min(errs) + (i-1)*(max(feature_errs) - min(errs))/number;
    num2 = min(errs) + i*(max(feature_errs) - min(errs))/number;
    y(i) = length(find(feature_errs>=num1)) - length(find(feature_errs>num2));
    feature_y(i) = length(find(errs>=num1)) - length(find(errs>num2));
end
y = y/sum(y);feature_y = feature_y/sum(feature_y);

t = y - feature_y;
for i = number-1:-1:2
    if t(i-1)*t(i) < 0
        fitting_threshold = min(errs) + i*(max(feature_errs) - min(errs))/number;
        break
    end
end

if fitting_threshold == 0
    for i = 2:number-1
        if y(i) ~= 0
            fitting_threshold = min(errs) + i*(max(feature_errs) - min(errs))/number;
            break
        end
    end
end
