## Copyright (C) 2020 Andreas Bertsatos <abertsatos@biol.uoa.gr>
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


% script for compiling left and right side measurement data from longbones into
% multivariate datasets. New variables (ratios of Ix/Iy and Imax/Imin as well as
% the ArPerIndex) are also calculated.
pkg load statistics;
pkg load io;
clear
bone = {"Ulna"};
side = {"Left", "Right"};
% load sex and age data from inventory
inventory = csvread("GR.csv");
% for each bone
b=1
	% load complete dataset in a cell structure including the headers of variable names
	data_all = csv2cell(cstrcat("Complete Data - ", bone{b}, ".csv"));
	% remove all angle measurements and Ixy variables
	data_all(:,[4:5,7,12,15,20,23,28,31,36,39,44,47]) = [];
	% load all measurements in a matrix and remove all angle variables
	data_num = csvread(cstrcat("Complete Data - ", bone{b}, ".csv"));
	data_num(1,:) = [];
	data_num(:,[1,4:5,7,12,15,20,23,28,31,36,39,44,47]) = [];
	% copy header and sample IDs in appropriate cell vectors
	header = data_all(1,:);
	sample_idx = data_all([2:end],1);
	% prepare two data sets for left and right side bones respectively
	L_idx = 1; R_idx = 1;
	LeftSideData(L_idx,:) = {header{1}, "sex", header{[2:end]}}; RightSideData = LeftSideData;
	% loop though all available samples
	for i=1:length(sample_idx)
		% check for side in the sample's ID string
		Lside = strfind(sample_idx{i},"_L");
		Rside = strfind(sample_idx{i},"_R");
		% cross reference its numerical ID to the inventory for sex and age
		sid = str2num(sample_idx{i}([4:6]));
		sex = inventory(find(inventory(:,1)==sid),2);
		age = inventory(find(inventory(:,1)==sid),3);
		% keep only left side elements of adult samples with known sex and age
		if (any(sex) && any(Lside) && age > 17)
			L_idx += 1;
			LeftSideData(L_idx,:) = {sample_idx{i}([1:6]), sex, num2cell(data_num(i,:)){:}};
		% keep only right side elements of adult samples with known sex and age
		elseif (any(sex) && any(Rside) && age > 17)
			R_idx += 1;
			RightSideData(R_idx,:) = {sample_idx{i}([1:6]), sex, num2cell(data_num(i,:)){:}};
		endif
	endfor
	% save each side's dataset in separate csv file
	 cell2csv(cstrcat("LeftSideData - ", bone{b}, ".csv"), LeftSideData);
	 cell2csv(cstrcat("RightSideData - ", bone{b}, ".csv"), RightSideData);
	% clear workspace except for "bone", "b", "side" and "inventory" variables
	clear -x "bone" "b" "side" "inventory" "mean_values" "sigma_values"

	% for each side load side data in a matrix, calculate a set of new variables, and normalize
	% all variables get header and sample id vectors from file
for s = 1:2
		SSD = csv2cell(cstrcat(side{s}, "SideData - ", bone{b}, ".csv"));
		header = SSD(1,:);
		sample = SSD([2:end],1);
		% get measurement data from file
		SSDd = csvread(cstrcat(side{s}, "SideData - ", bone{b}, ".csv"));
		SSDd(1,:) = [];
		% keep maxDistance, angle65-80, Areas, Perimeters, Ix, Iy, Imin, Imax and create new variables with ratios
		% of Ix/Iy and Imax/Imin as well as ArPerIndex for each cross section (i.e. 20%, 35%, 50%, 65%, 80%)
		SSDnV = SSDd(:,[2:7]);
		SSDnV = [SSDnV, ((SSDd(:,6))*(4*pi))./(SSDd(:,7).^2), SSDd(:,[8:9]), SSDd(:,8)./SSDd(:,9)];
		SSDnV = [SSDnV, SSDd(:,[10:11]), SSDd(:,11)./SSDd(:,10), SSDd(:,[12:13])];
		%
		SSDnV = [SSDnV, ((SSDd(:,12))*(4*pi))./(SSDd(:,13).^2), SSDd(:,[14:15]), SSDd(:,14)./SSDd(:,15)];
		SSDnV = [SSDnV, SSDd(:,[16:17]), SSDd(:,17)./SSDd(:,16), SSDd(:,[18:19])];
		%
		SSDnV = [SSDnV, ((SSDd(:,18))*(4*pi))./(SSDd(:,19).^2), SSDd(:,[20:21]), SSDd(:,20)./SSDd(:,21)];
		SSDnV = [SSDnV, SSDd(:,[22:23]), SSDd(:,23)./SSDd(:,22), SSDd(:,[24:25])];
		%
		SSDnV = [SSDnV, ((SSDd(:,24))*(4*pi))./(SSDd(:,25).^2), SSDd(:,[26:27]), SSDd(:,26)./SSDd(:,27)];
		SSDnV = [SSDnV, SSDd(:,[28:29]), SSDd(:,29)./SSDd(:,28), SSDd(:,[30:31])];
		%
		SSDnV = [SSDnV, ((SSDd(:,30))*(4*pi))./(SSDd(:,31).^2), SSDd(:,[32:33]), SSDd(:,32)./SSDd(:,33)];
		SSDnV = [SSDnV, SSDd(:,[34:35]), SSDd(:,35)./SSDd(:,34)];

		% append all new variable data to a cell array and save in csv file
		Results = {header([1:7]){:}, "ArPerIndex 20%", header([8:9]){:}, "Ix/Iy 20%", header([10:11]){:},...
							"Imax/Imin 20%", header([12:13]){:}, "ArPerIndex 35%", header([14:15]){:}, "Ix/Iy 35%",...
							header([16:17]){:}, "Imax/Imin 35%", header([18:19]){:}, "ArPerIndex 50%",...
							header([20:21]){:}, "Ix/Iy 50%", header([22:23]){:}, "Imax/Imin 50%", header([24:25]){:},...
							"ArPerIndex 65%", header([26:27]){:}, "Ix/Iy 65%", header([28:29]){:}, "Imax/Imin 65%",...
							header([30:31]){:}, "ArPerIndex 80%", header([32:33]){:}, "Ix/Iy 80%", header([34:35]){:},...
							"Imax/Imin 80%"};
		for i=1:size(SSDnV,1)
			Results(i+1,:) = {sample{i}, num2cell(SSDnV(i,:)){:}};
		endfor
		 cell2csv(cstrcat(side{s}, "SideNewData - ", bone{b}, ".csv"), Results);

    % detect all outliers and remove then from data set by replacing with NaN values
		data = csv2cell(cstrcat(side{s}, "SideNewData - ", bone{b}, ".csv"));
		var_names = data(1,[3:end]);
		Males = data(find(cell2mat(data([2:end],2))==1)+1,:);
		Females = data(find(cell2mat(data([2:end],2))==2)+1,:);
		for v=1:48
			D(v).values = {cell2mat(Males(:,v+2)), cell2mat(Females(:,v+2))};
			D(v).groups = {Males(:,1), Females(:,1)};
			figure(v);
			[Stats,H(v)] =  boxplot(D(v).values, "Symbol", ['x','*'], "OutlierTags", "on", "Positions", [1,3],...
							 "Sample_IDs", D(v).groups, "Labels", {"Males", "Females"}, "BoxWidth", "fixed", "Widths", 0.4, "BoxStyle", "filled");
			set(gca, "title", cstrcat(var_names{v}," for Left Ulna"));
			outliers = [get(H(v).out_tags, "string"); get(H(v).out_tags2, "string")];
			for out_i=1:length(outliers)
				data(find(strcmp(outliers(out_i),data(:,1))), v+2) = NaN;
			endfor
			cell2csv(cstrcat(side{s}, "SideNo_Outliers - ", bone{b}, ".csv"), data);
		endfor
		close all

endfor


% Create a pooled sample dataset combining both sides for each sex
left_no_out = csv2cell("LeftSideNo_Outliers - Ulna.csv");
left_no_out(2:end,1) = strcat(left_no_out(2:end,1), "_L");
right_no_out = csv2cell("RightSideNo_Outliers - Ulna.csv");
right_no_out(2:end,1) = strcat(right_no_out(2:end,1), "_R");
pooled = [left_no_out; right_no_out(2:end,:)];
cell2csv("Pooled_sample.csv", pooled); % save the pooled dataset in a csv file
