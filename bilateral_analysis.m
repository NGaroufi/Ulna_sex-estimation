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
pkg load nan;
clear

%% Create two separate datasets for the two sexes

% load sex and age data from inventory
inventory = csvread("GR.csv");

% Setting up a for-loop for the two sides
side = {"Left", "Right"};
for s = 1:2
  % CSV file loading
  data = csv2cell(cstrcat(side{s}, "SideNo_Outliers - Ulna.csv"));
  num_data = csvread(cstrcat(side{s}, "SideNo_Outliers - Ulna.csv")); % Numerical
  num_data(1,:) = []; % Delete the first row
  num_data(:, [1,2]) = []; % Delete the first two columns and keep the measurements
  header = {data(1,[1:2]){:}, "age", "chrono age", data(1,[3:end]){:}};
  sample_idx = data([2:end],1);
  m_idx = 1; f_idx = 1;

  % Creating two datasets for male and female individuals, including age-at-death
  % and chronological age
  for i=1:length(sample_idx)
    sid = str2num(sample_idx{i}([4:6]));
    sex = inventory(find(inventory(:,1)==sid),2);
    age = inventory(find(inventory(:,1)==sid),3);
    c_age = inventory(find(inventory(:,1)==sid),4);
		if (sex == 1)
			m_idx += 1;
			m_data(m_idx,:) = {sample_idx{i}([1:6]), sex, age, c_age, num2cell(num_data(i,:)){:}};
		elseif (any(sex))
			f_idx += 1;
			f_data(f_idx,:) = {sample_idx{i}([1:6]), sex, age, c_age, num2cell(num_data(i,:)){:}};
		endif
  endfor

  % Cleaning up the datasets and saving the full versions as csv files
  m_data(1,:) = header(1,:);
  f_data(1,:) = header(1,:);

  %Save those two datasets as csv files
  cell2csv(cstrcat(side{s}, "Side - Males.csv"), m_data);
  cell2csv(cstrcat(side{s}, "Side - Females.csv"), f_data);

  clear m_data f_data age c_age i m_idx f_idx sex sid

endfor

clear

%% Bilateral asymmetry check - will be performed with Wilcoxon paired test
%% separately for male and female individuals

sex = {"Males", "Females"};


for s = 1:2
  l_data = csv2cell(cstrcat("LeftSide - ", sex{s}, ".csv"));
  r_data = csv2cell(cstrcat("RightSide - ", sex{s}, ".csv"));
  header=l_data(1,:);

  % Keep only the variables that exhibited statistically significant sexual
  % dimorphism (according to JASP) for the left and right datasets, and the header
  l_data(:,[2:4, 10, 13, 16, 22, 25, 28, 31, 34, 40, 46, 49, 52])=[];
  l_data(1,:)=[];
  r_data(:,[2:4, 10, 13, 16, 22, 25, 28, 31, 34, 40, 46, 49, 52])=[];
  r_data(1,:)=[];

  header(:,[2:4, 10, 13, 16, 22, 25, 28, 31, 34, 40, 46, 49, 52])=[];

  % Hold the sample IDs of the paired bones (both datasets)
  t = [intersect(l_data(:,1), r_data(:,1))];

  % Isolate the data for the paired samples from the left side and the right side
    for i = 1:length(l_data)
      if ismember(l_data(i,1), t) == 1
        lp_data(i,:) = l_data(i,:);
      endif
    endfor

    for i = 1:length(r_data)
      if ismember(r_data(i,1), t) == 1
        rp_data(i,:) = r_data(i,:);
      endif
    endfor

  % Delete any empty rows
  lp_data = lp_data(~all(cellfun(@isempty,lp_data),2),:);
  rp_data = rp_data(~all(cellfun(@isempty,rp_data),2),:);

  clear l_data r_data t i

  % Perform the wilcoxon_test and save the p-values, the statistics, and the left
  % and right side medians for each variable
    for i = 1:36
      [p{i},z{i}] = wilcoxon_test(cell2mat(lp_data(:,i+1)), cell2mat(rp_data(:,i+1)));
      d_l{i} = nanmedian(cell2mat(lp_data(:,i+1)));
      d_r{i} = nanmedian(cell2mat(rp_data(:,i+1)));
      as{i} = 100/max(d_l{i},d_r{i})*min(d_l{i},d_r{i})*(-1)+100;
      if d_l{i} > d_r{i}
        as{i} = as{i}*(-1);
      endif
    endfor

  % Save in a CSV file
  cols = {"Variable", "Median (L)", "Median (R)", "P-value", "Statistic", "% Asymmetry"};
  cell2csv(cstrcat("BA_", sex{s}, ".csv"), [cols; header(:,2:end)', d_l', d_r', p', z', as'])

  clear d_l d_r lp_data rp_data p z as

endfor

clear
