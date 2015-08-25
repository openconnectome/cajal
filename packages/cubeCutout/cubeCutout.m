function cubeCutout(dataset, queryFile, outputFile, useSemaphore, objectType, serviceLocation)
    %cubeCutout - This function saves a file with the specified cube
    %   
    % The input is a OCPQuery that typically is generated by
    % cubeCutoutPreprocess.  
    %
    % This module can save the retrieved cube as either a RAMONVolume
    % (which is the default) stored in a .mat file or an HDF5 .h5 file by
    % setting the objectType flag.  If omitted a RAMONVolume is
    % created.
    %
    % 0 = RAMONVolume in .mat format
    % 1 = HDF5 dataset in .h5 format
    %
    %
    %                       Revision History
    % Author            Date                Comment
    % D.Kleissas    15-May-2012     Initial Release
    % D.Kleissas    14-Mar-2014     Added external service location setting
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Copyright 2015 The Johns Hopkins University / Applied Physics Laboratory 
    % All Rights Reserved. 
    % Contact the JHU/APL Office of Technology Transfer for any additional rights.  
    % www.jhuapl.edu/ott
    %  
    % Licensed under the Apache License, Version 2.0 (the "License");
    % you may not use this file except in compliance with the License.
    % You may obtain a copy of the License at
    %  
    %     http://www.apache.org/licenses/LICENSE-2.0
    %  
    % Unless required by applicable law or agreed to in writing, software
    % distributed under the License is distributed on an "AS IS" BASIS,
    % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    % See the License for the specific language governing permissions and
    % limitations under the License.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %% Create data access object        
    if ~exist('useSemaphore','var')
        useSemaphore = false;
    end     
    if ~exist('objectType','var')
        objectType = 0;
    end    
    if ~exist('serviceLocation','var')
        serviceLocation = 'http://openconnecto.me/';
    end
    
    validateattributes(dataset,{'char'},{'row'});
    validateattributes(queryFile,{'char'},{'row'});    
    
    if useSemaphore == 1        
        oo = OCP('semaphore');
    else
        oo = OCP();
    end
    
    oo.setServerLocation(serviceLocation);
    oo.setImageToken(dataset);

    
    %% Load Query
    queryObj = OCPQuery.open(queryFile);
       
    %% Get Data and save file
    
    cube = oo.query(queryObj); 
            
    switch objectType
        case 0
            save(outputFile,'cube');
        case 1                       
            % Save relevant "cutout" RAMONVolume fields to HDF5 file.
            % data, dataFormat, xyzOffset, resolution, etc.
            OCPHdf(cube,outputFile);
            
        otherwise            
            error('cubeCutout:DATAFORMATERROR','Invalid output type:%d',objectType);
    end

end

