#!/usr/bin/env python3
from pathlib import Path
import subprocess
import argparse
import sys
import shutil

def convert_wavfile(wavfile, outfile):
    """
    Converts file to 8khz single channel mono wav
    """
    cmd = "ffmpeg -y -i {} -acodec pcm_s16le -ar 8000 -ac 1 {}".format(
        wavfile, outfile)
    subprocess.Popen(cmd, shell=True).wait()
    return outfile


def create_8k(scp_file,
          data_8k,
          outfile,
          ):
        # clear out file first
        open(outfile, 'w').close()
        # Load scp file
        wav_list_file = open(scp_file, 'r')
        wav_list = wav_list_file.readlines()
        with open(outfile, 'a') as fp:
            wav_line = "{} {}\n"
            for wav in wav_list:
                wav_name = wav.split()[0]
                flac_file= wav.split()[2]
                out_file = Path(data_8k, wav_name + '.wav')
                convert_wavfile(wavfile=flac_file, outfile=out_file)

                line = wav_line.format(wav_name, out_file)
                fp.write(line)

if __name__ == "__main__":

    """Main."""
    parser = argparse.ArgumentParser(
        description='Convert to 8kHz.',
        add_help=True)
    parser.add_argument(
        'source_dir', metavar='source_dir', type=Path,
        help='path to folder of original data')
    parser.add_argument(
        'output_8k', metavar='output_8k', type=Path,
        help='path to directory saving .wav file of 8kHz')
    parser.add_argument(
        'out_dir', metavar='out_dir', type=Path,
        help='path to folder saving 8kHz data')
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    args = parser.parse_args()

    print("start convert to 8kHz")
    create_8k(Path(args.source_dir, 'wav.scp'),
          args.output_8k,
          Path(args.out_dir, 'wav.scp')
          )
    
    shutil.copyfile(Path(args.source_dir, 'reco2num_spk'), Path(args.out_dir, 'reco2num_spk'))
    shutil.copyfile(Path(args.source_dir, 'rttm'), Path(args.out_dir, 'rttm'))
    shutil.copyfile(Path(args.source_dir, 'segments'), Path(args.out_dir, 'segments'))
    shutil.copyfile(Path(args.source_dir, 'spk2utt'), Path(args.out_dir, 'spk2utt'))
    shutil.copyfile(Path(args.source_dir, 'utt2spk'), Path(args.out_dir, 'utt2spk'))

    print("Output of 8kHz data in ", args.out_dir)