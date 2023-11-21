## Copyright (C) 2023 Nefeli Garoufi <nefeligar@biol.uoa.gr>
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

% Package loading
pkg load statistics;
pkg load io;
clear

% Load the inventory (age, sex) for the Athens Collection dataset
inventory = csvread("GR.csv");

pooled = csv2cell("Pooled_sample.csv");

% Store IDs in a vector and save the last three characters than indicate the number
% of the individual
psids = pooled(2:end,1);
for i=1:length(psids)
   pooled_sample_ids{i} = psids{i}([4:6]);
endfor
pooled_sample_ids = [pooled_sample_ids]';
un_psids = unique(pooled_sample_ids); %keep only the unique instances
un_psids = cell2mat(un_psids);
un_psids = str2double(un_psids);

% store the age and sex of each unique individual
for i=1:length(un_psids)
  sex(i) = inventory(find(inventory(:,1)==un_psids(i)),2);
  age(i) = inventory(find(inventory(:,1)==un_psids(i)),3);
endfor

pooled_inv = [sex', age', c_age'];

%% HISTOGRAMS %%

fs = 10;

% Calculate the means and standard deviation from the pooled inventory (unique)
% and the size of the bins for the histograms
mv = mean(pooled_inv(:,2));
stv = std(pooled_inv(:,2));
bins = ([-60:2:60]*0.1)' * 2*ceil(stv/2) + round(mv);

% Store the histograms in two structure
[nm, bcm] = hist(pooled_inv(find(pooled_inv(:,1)==1),2), bins(:,1)');
[nf, bcf] = hist(pooled_inv(find(pooled_inv(:,1)==2),2), bins(:,1)');

clf;
 subplot (1, 2, 1)
 bar(bcm, nm, 'facecolor', "#2B58A1", 'edgecolor', "#1B6D81"); xlim([15, 103]); ylim([0,15]);
 title ("x & y labels & ticklabels");
 set(get(gcf, "currentaxes"), "fontsize", fs);
 set(gca, 'xtick', [15:10:103]); %round(bins_m(1:5:121)));
 title(" Age-at-death Distribution\nMales", "fontsize", 15);
 xlabel("age (years)", "fontsize", fs, "fontangle", "italic");
 ylabel("number of cases", "fontsize", fs, "fontangle", "italic");

 subplot (1, 2, 2);
 bar(bcf, nf, 'facecolor', "#E9BDD2", 'edgecolor', "#A60651"); xlim([15, 103]); ylim([0,15]);
 set(get(gcf, "currentaxes"), "fontsize", fs);
 set(gca, 'xtick', [15:10:103]); %round(bins_f(1:5:121)));
 title(" Age-at-death Distribution\nFemales", "fontsize", 15);
 xlabel("age (years)", "fontsize", fs, "fontangle", "italic");
 ylabel("number of cases", "fontsize", fs, "fontangle", "italic");

% export plot
print -dpng "-S1200, 700" Sample_Age-at-death.png
close

