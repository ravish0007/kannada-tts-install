#!/bin/bash
ROOT=$(git rev-parse --show-toplevel)
ROOT="${ROOT:-$(pwd)}"
BUILD="${ROOT}/build"
DOWNLOAD_PATH="${BUILD}"/packages
COMPILE_PATH="${BUILD}"/compiled
RUNDIR="${DOWNLOAD_PATH}"/HTS-demo_CMU-ARCTIC-SLT





kannada_tts_setup() {
    CURRENTDIR=$(pwd)
    #Register here http://htk.eng.cam.ac.uk/download.shtml and get a username and password
    HTKUSER=ravish
    HTKPASSWORD=rwd69H+g

    sudo apt-get install -y wget valgrind git festival  libx11-dev perl build-essential g++ csh gawk bc sox tcsh default-jre lame

    mkdir -p "${DOWNLOAD_PATH}"
    mkdir -p "${COMPILE_PATH}"

   cd "${DOWNLOAD_PATH}"
   if [[ ! -d unified ]]; then
 #       wget --no-check-certificate http://127.0.0.1:80/unified.zip
        wget --no-check-certificate https://www.iitm.ac.in/donlab/tts/downloads/unified/unified.zip
        unzip unified.zip
        cd unified
        make
        sudo ln -s  unified-parser /usr/local/bin/unified-parser
    fi 


   cd  "${DOWNLOAD_PATH}"
      if [[ ! -d festival ]]; then
	git clone http://github.com/festvox/festival
#	wget  http://127.0.0.1/festival.zip ; unzip festival
	cd festival
	./configure
	make
	make default_voices
	cd ..
       fi
	


    cd "${DOWNLOAD_PATH}"
    if [[ ! -d HTS-demo_CMU-ARCTIC-SLT ]]; then
        wget --no-check-certificate  http://hts.sp.nitech.ac.jp/archives/2.3/HTS-demo_CMU-ARCTIC-SLT.tar.bz2  
#        wget --no-check-certificate  http://127.0.0.1:80/HTS-demo_CMU-ARCTIC-SLT.tar.bz2  
        tar xvBf HTS-demo_CMU-ARCTIC-SLT.tar.bz2
	cd HTS-demo_CMU-ARCTIC-SLT
	sed -i  s/default=cmu_us_arctic/default=iitm_unified/ ./configure
        sed -i  s/default=slt/default=don/ configure
	sed -i s/DATASET=cmu_us_arctic/DATASET=iitm_unified/ ./configure
	sed -i s/SPEAKER=slt/SPEAKER=don/ configure
	sed -i s/\ \&/\ / ./Makefile.in 

    fi

    cd "${DOWNLOAD_PATH}"
    if [[ ! -f iitm_unified_don.htsvoice ]]; then
        curl  https://www.iitm.ac.in/donlab/tts/downloads/voices/hts2310hr/iitm_unified_don_kannadaMale10hr.htsvoice --output iitm_unified_don.htsvoice 
 #       curl  http://127.0.0.1:80/iitm_unified_don_kannadaMale10hr.htsvoice --output iitm_unified_don.htsvoice 
    fi




    cd "${DOWNLOAD_PATH}"
    if [[ ! -d ssn_hts_demo ]]; then
#	wget --no-check-certificate http://127.0.0.1/ssn_hts_demo_tamil_male.tgz
	wget --no-check-certificate https://www.iitm.ac.in/donlab/tts/downloads/voices/hts23/ssn_hts_demo_tamil_male.tgz
	tar xvzf ssn_hts_demo_tamil_male.tgz
    fi

    cd "${DOWNLOAD_PATH}"
    if [[ ! -d SPTK-3.10 ]]; then
	wget --no-check-certificate https://nchc.dl.sourceforge.net/project/sp-tk/SPTK/SPTK-3.10/SPTK-3.10.tar.gz
#	wget --no-check-certificate http://127.0.0.1/SPTK-3.10.tar.gz
	tar xvzf SPTK-3.10.tar.gz
    fi
    cd SPTK-3.10
    ./configure --prefix="${COMPILE_PATH}"/sptk
    make
    make install

    cd "${DOWNLOAD_PATH}"
    if [[ ! -d hts-htk ]]; then
	mkdir hts-htk
    fi
    cd hts-htk
    if [[ ! -f HTS-2.3_for_HTK-3.4.1.patch ]]; then
#	wget --no-check-certificate http://127.0.0.1/HTS-2.3_for_HTK-3.4.1.tar.bz2
	wget --no-check-certificate http://hts.sp.nitech.ac.jp/archives/2.3/HTS-2.3_for_HTK-3.4.1.tar.bz2
	tar xvjf HTS-2.3_for_HTK-3.4.1.tar.bz2
    fi

    cd "${DOWNLOAD_PATH}"
    if [[ ! -d htk ]]; then
#	wget --no-check-certificate  http://127.0.0.1/HTK-3.4.1.tar.gz 
	wget --no-check-certificate  http://htk.eng.cam.ac.uk/ftp/software/HTK-3.4.1.tar.gz --user="${HTKUSER}" --password="${HTKPASSWORD}"
	tar -zxvf HTK-3.4.1.tar.gz
    fi

    if [[ ! -f htk/HTKLVRec/HLVRec.c ]]; then
#	wget --no-check-certificate http://127.0.0.1/HDecode-3.4.1.tar.gz
	wget --no-check-certificate http://htk.eng.cam.ac.uk/ftp/software/hdecode/HDecode-3.4.1.tar.gz --user="${HTKUSER}" --password="${HTKPASSWORD}"
	tar -zxvf HDecode-3.4.1.tar.gz
    fi
    cd htk
    patch --dry-run -s -N -p1 -d . < ../hts-htk/HTS-2.3_for_HTK-3.4.1.patch
    if [[ "${?}" -eq 0 ]]; then
	patch -s -N -p1 -d . < ../hts-htk/HTS-2.3_for_HTK-3.4.1.patch
    fi
   #  ./configure  CFLAGS="-DARCH=linux"  --prefix="${COMPILE_PATH}"/htk
    ./configure      --prefix="${COMPILE_PATH}"/htk
    make
    make install

    cd "${DOWNLOAD_PATH}"
    if [[ ! -d hts_engine_API-1.10 ]]; then
#	wget --no-check-certificate https://127.0.0.1/hts_engine_API-1.10.tar.gz
	wget --no-check-certificate https://nchc.dl.sourceforge.net/project/hts-engine/hts_engine%20API/hts_engine_API-1.10/hts_engine_API-1.10.tar.gz
	tar xvzf hts_engine_API-1.10.tar.gz
    fi
    cd hts_engine_API-1.10
    ./configure --prefix="${COMPILE_PATH}"/hts_engine_api
    make
    make install

    cd "${DOWNLOAD_PATH}"/festival/examples/
    if [[ ! -f dumpfeats ]]; then
	sudo  gunzip dumpfeats.gz
    fi
    if [[ ! -f dumpfeats.sh ]]; then
	sudo gunzip dumpfeats.sh.gz
    fi
    sudo chmod a+rx "${DOWNLOAD_PATH}"/festival/examples/dumpfeats



    cd "${DOWNLOAD_PATH}"
    if [[ ! -d supporting_scripts ]]; then
     wget --no-check-certificate https://www.iitm.ac.in/donlab/tts/downloads/synthesisDocs/supporting_scripts.zip 
#    wget --no-check-certificate http://127.0.0.1/supporting_scripts.zip 
    unzip supporting_scripts.zip
    cp -r supporting_scripts/HTS23_synthesis_helper_scripts/* "${DOWNLOAD_PATH}"/HTS-demo_CMU-ARCTIC-SLT

    fi


    cd "${DOWNLOAD_PATH}"

    cd HTS-demo_CMU-ARCTIC-SLT
    if [[ ! -f "${DOWNLOAD_PATH}"/festival/radio_phones.scm-old ]]; then
        sudo mv "${DOWNLOAD_PATH}"/festival/radio_phones.scm "${DOWNLOAD_PATH}"/radio_phones.scm-old
        sudo cp "${DOWNLOAD_PATH}"/ssn_hts_demo/radio_phones.scm "${DOWNLOAD_PATH}"/festival/
    fi

    if [[ ! -f /usr/share/perl5/File/Slurp.pm ]]; then
        mkdir -p /usr/share/perl5/File
        sudo cp "${DOWNLOAD_PATH}"/ssn_hts_demo/Slurp.pm /usr/share/perl5/File/
    fi

    sudo cp "${DOWNLOAD_PATH}"/festival/examples/text2utt.sh /usr/bin/text2utt 
    sudo cp  "${DOWNLOAD_PATH}"/festival/examples/dumpfeats.sh /usr/bin/dumpfeats 

        ./configure --with-fest-search-path="${DOWNLOAD_PATH}"/festival/examples  \
                    --with-sptk-search-path="${COMPILE_PATH}"/sptk/bin \
                     --with-hts-search-path="${COMPILE_PATH}"/htk/bin  \
                --with-hts-engine-search-path="${COMPILE_PATH}"/hts_engine_api/bin
        mkdir -p "${DOWNLOAD_PATH}"/HTS-demo_CMU-ARCTIC-SLT/voices/qst001/ver1/
        mkdir -p "${DOWNLOAD_PATH}"/HTS-demo_CMU-ARCTIC-SLT/gen/qst001/ver1/hts_engine


        cp  "${DOWNLOAD_PATH}"/iitm_unified_don.htsvoice  "${DOWNLOAD_PATH}"/HTS-demo_CMU-ARCTIC-SLT/voices/qst001/ver1/

        sed -i s/=\ 1\;/\=\ 0\;/ scripts/Config.pm
        sed -i s/\$ENGIN\ =\ 0\;/\$ENGIN\ =\ 1\;/ scripts/Config.pm


  	 local file=scripts/Training.pl" line="# POSSIBILITY OF SUCH DAMAGE.                                       #" 
   	local newText="use lib '.', 'scripts'\;"
   	sed -i -e "/^$line$/a"$'\\\n'"$newText"$'\n' "$file"


    	cd "${CURRENTDIR}"
    	echo "installation completed"

}



################################ Not yet modified

kannada_tts_run() {
    if [[ -z "${SOURCE}" ]]; then
	echo "${USAGE}"
	exit 1
    fi

    if [[ -z "${OUTPUT}" ]]; then
	OUTPUT="${SOURCE%.*}.wav"
    fi

    SOURCE=$(readlink -f "${SOURCE}")
    OUTPUT=$(readlink -f "${OUTPUT}")
    MP3OUTPUT="${OUTPUT%.*}.mp3"
    CURRENTDIR=$(pwd)

    rm -f "${OUTPUT}" "${MP3OUTPUT}"
    cp -fra "${RUNDIR}" "${RUNDIR}_${RUNID}"
    RUNDIR="${RUNDIR}_${RUNID}"
    cd "${RUNDIR}"
    ./configure --with-fest-search-path="${DOWNLOAD_PATH}"/festival/examples --with-sptk-search-path="${COMPILE_PATH}"/sptk/bin/ --with-hts-search-path="${COMPILE_PATH}"/htk/bin/ --with-hts-engine-search-path="${COMPILE_PATH}"/hts_engine_api/bin/
    ./scripts/complete "${SOURCE}" linux
    cd "${CURRENTDIR}"
    if [[ $(stat -c '%s' "${RUNDIR}"/wav/1.wav) -eq 0 ]]; then
	echo "output file genertion failed" 1>&2
	rm -fr "${RUNDIR}"
	exit 1
    fi

    cp "${RUNDIR}"/wav/1.wav "${OUTPUT}"
    rm -fr "${RUNDIR}"

    if [[ "${MP3}" -eq 1 ]]; then
	lame "${OUTPUT}" "${MP3OUTPUT}"
	rm -f "${OUTPUT}"
    fi
}


##########################################







kannada_tts_clean() {
    rm -fr "${BUILD}"
}

USAGE="[usage]
	${0} --clean
	${0} --setup
	${0} --run [--runid id] [--gen-mp3] [--output outputfile ] --source sourcefile
	${0} -h|--help
"

ARGS=$(getopt -o h -l clean,setup,run,gen-mp3,runid:,source:,output:,help -n "${0}" -- "${@}")
if [[ ! "${?}" -eq 0 ]]; then
    echo "failed parse options" 1>&2
    exit 1
fi

eval set -- "${ARGS}"
CLEAN=0
SETUP=0
RUN=0
MP3=0
RUNID="${$}"
SOURCE=""
OUTPUT=""

while true; do
    case "${1}" in
	--clean) CLEAN=1; shift;;
	--setup) SETUP=1; shift;;
	--run) RUN=1; shift;;
	--gen-mp3) MP3=1; shift;;
	--runid) RUNID="${2}"; shift 2;;
	--source) SOURCE="${2}"; shift 2;;
	--output) OUTPUT="${2}"; shift 2;;
	--) shift; break;;
	*) echo "${USAGE}"; exit 1;;
    esac
done

if [[ "${CLEAN}" -eq 1 ]]; then
    kannada_tts_clean
fi

if [[ "${SETUP}" -eq 1 ]]; then
    kannada_tts_setup
fi

if [[ "${RUN}" -eq 1 ]]; then
    kannada_tts_run
fi
