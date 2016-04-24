#!/bin/bash

set -u

PROJN=secdir # var to define

export USER_WD=$PWD

if [[ "$*" =~ --rt: ]]; then
	[[ "$*" =~ --rt:ls ]] && { cat "$0"|sed '1,55 d'|tar tz ; }

	[[ "$*" =~ --rt:env ]] && { env ; }

	[[ "$*" =~ --rt:extract ]] && {
		mkdir -p "$PROJN.d"
		cat "$0"|sed '1,55 d'|tar xz -C "$PROJN.d"
		}

exit
fi

tarrunid=f19b4d0eab66e54710c048c3b6f1f096
TARRUNPREFS="$HOME/.tarrun.db"

prevrun=
doextract=
if [[ -f "$TARRUNPREFS" ]]; then
	prevrun=$(grep -o -P "(?<=$PROJN ).+" "$TARRUNPREFS") # TODO change this so that it uses the current file to store info!
fi

if [[ -n "$prevrun" ]] && [[ "${prevrun:0:32}" = $tarrunid ]]; then # previous run same as this one
	sfil=$(echo "$prevrun"|cut -d' ' -f2)
	if [[ ! -d "$sfil" ]]; then
		doextract=yes
	fi
else # new version being run
	sfil=$(mktemp --tmpdir -d "$PROJN-XXX")
	sed "/$PROJN/d" -i "$TARRUNPREFS" 2>/dev/null # remove old version if present
	echo "$PROJN $tarrunid $sfil" >> "$TARRUNPREFS" # register this version
	doextract=yes
fi

if [[ -z "$sfil" ]]; then echo "Danger - empty tmp dir name detected!" 1>&2; exit 1 ; fi

if [[ $doextract = yes ]] || [[ "$*" =~ "--rt:restore" ]]; then # special restore option
	rm -rf "$sfil" && mkdir -p "$sfil"
	cat "$0"|sed '1,55 d'|tar xz -C "$sfil"
	if [[ "$*" =~ "--rt:restore" ]]; then exit $?; fi
fi

cd "$sfil/"
export APPLICATION_WD=$PWD
"./tarrun-shim.sh" "$@"
res=$?
exit $res
� (W �<kS�Ȳ�j���eV�֘ ?xց�c�!�L��䤀�
i�UؒK8��v����l��N��ޫ��`ϣ�{��3=.WnB{d�;�N�͏�*���6���nWտ��m�Vw7j;խ�7�Zmwc���!Ԥ ��c�M`�_l�R�_���7]g`�zܰ�W���3�?�뿽��^����V��~�����O�۩��0�ϯ�~��t���lS�,>�Κ�����I����&I	뒘�߸�{7$G�K���Q���s�,r&+�;p6�G<���-��.��rL�M��a#װ�3s=��s3���Rc4��T�\3�������_���B1�k5����Y�U�V��%M� ��(K��T�}���H0��X ���q�i:����|���K��L+D4v}��؝|.70`��v���4q������j�����s��-�o]+���LA��z��s��3��Օ�Z��"LH.9M@>'�	X�f>5Ub:�O�il�E�܁2oKfCA��$�Pc��ڃ�{O�DSDS�]]�����:�n��ت��Cs8�Y��l�#���\�Z���J㻀�a]�`<�l���3oP-��_��O�!R�j)�n�g�dG��R�ՙ�`�:1���E�brr|$P�R��D�h�G9�^u��,��X�e.�'b�]����
�X�G�X���\D�:{� )1�)ʹd�G���>�N�	4>��Оzd;n�u>�e�x�sˀ@Ǖmm�BXP5 �;�@=�5�^���A/��qo����A�9�`?��	�)�� ���O���`���!7�h,1<ҏ=�&;@j'�^�)�ix�������ErKZ�&���7�[�����XA4=-e,�{bb�E���MwX���ӏX�^d��	�d�
��x�.M6�`��Eȿ��������հ��0��ܱ��4��E���Z�j��=(�t�ݹ(rx(#$O�8 Yb����D��	��#�G�X���2�F��Z�vi��vJ������3�F.���Έ8����Fԃ���6��?O<���$�_��l�y,���@YC�y�ik-�Q�V��϶����SUv[«@��D�/�6���w�����
5M:LmY=�yKKX|��y�mLCn����k�Q4�b%��_��8�H�9�Τ��'I;��ڵB�O�	����=����H5��`�H�����?��ކ�-�#� oggkY�W���M�[;�j��$�?��⪱�q���.|�����l
�X8��m�A?'�@��Ѕ=0y� ��5A���rkm�O��^x�U*ZQ�hWWE�9��X����������Å�v�2I�ĶZ,4�gPi�=���?�`�c�lE�R�P�fBh&� �Q������PaI�����XG�G�Q�twKZQ�R�����J!�.\���hk��F��u ���cpۀ��;��q��㞁�����~�=T��Ķ����_=��g��e�����
�X)��R�-�-&�v����ux�!�=�sV�W*��Je�(��^�Z�~[��*+W5��R.��̷*@+(.��C���L��U%@�G�5�ġ;�x�aaa�hZpN^Q��i!��Q�a������66��9�_����k@B��U��8??i7�|}�:"at*E����a��a�������i��k��1�P���p���1�h��X��i6j룢��AGu#4����;�r��XCǽ1́^�V#��#�̓���gj�Wh���Z�y�:�����G�ʶ3p_d�QP��������4�w�e���Y�I�Ԁ��%:�h�ۢ��
�	09['��3���$\∠&L�2���[�)�#�<#����s@<k#::�&�	�7�E�P���!�"��� X�(r�Jȭy~�3��w\�>7���V)��wy2�X�8_V��]�-�9q��'TLۚp��Q�Ait��{Ԏ���Xh)�?a�%�F��H2z�Q�A��V��:|nu��.;j�O`� ;%���]+�q�Dc9�\ ��sY���#��w\SŚ��/�mƱ�D�u�x�u�b�]{8��
�/��/�!M���B����������;��H�+R7�������U>�43���N8����@����gO:�i�J+���bN�	]�=ET):���6�����ű�."�6e�1A�qz/�_��� 5DdCt�|�����~݁Q������=��''�`����c:��H�ݬ��d�4iw4�l�+w�0��`�`4�*D�`��a��y4�эg�R�T��(,�|��֋+EE[ǫ��gf��)���s��y�j�+�^�_9ڬ�0q�V��ot��Z�����������(��xR�������!+�z~�Y�KܕU��a�mK�����>�X�mP�[���e�w��{���:m���/k��W�������ėn���,cf���,��y�_����� ͯ�m<.q�r�X�/�#�do�%��D:����=v�::즱��G{�D��)�El�+%0���V�So��2�����2j�k��5tG-pI�1�ᖴ��l�h%�)]"�{D�.���9Es�?jp��l����Yۚ��7���U a��g:q�H�.�YD	X�YS� "����B*�T� ���-�L"��AEy qB���@���b���=�E(W0S��1���=����U��?_��ד���A�~�1^���[���ܨne��5`���	f�2wL)��|�ީa;Q��n���>�b1�#p.x)�_��� ��a���l��H��T�O��ɜZ�bM�07�ҺD�l�('���a�[ǻ��1�@k�[��Q����Q~�T�����V�B���T���c�xi�W�6���w67���p���:�����N1���]B�%�N��l%��A�+r���+ ����A���m?�K�?� ����Vu7���	��N���~�uM9D$�O�7[�Tn��c��8j����b�t4j;!g"�%J0>���(�N�#9L�1���������Zoʢ`�x�����Z
�͋^�������K�cq����%8�s�r"X��:%NG���|����T��ux\�Ufi5��rj��S����t[,U,�����b*cauj2}��m	jV�׎t�+L]���B���e{?r��-��kx����7���U ��ٛ݋���c:�o;"Q��5�u�e�gC�F��F�@e:�(�wv���������o�[5Kl�Z�a}�f�p�w�{��]��7P��_�ܻ�V�Nһܲ1q�&�]��W2c	K��{��Owe<�.2N�{���ǡ!n	��o�"�7�%&��c�3n=c2D\��
'������K�H̘���z\ǋ �{��S�`�lc�S'H��B�{DC�]���süs��[�0q仃`��O�j���;!���OM6��2��s�:h�鿘"{�)W���z0���T�݀�_+4ʳ�i ��pf��&Ư'�H���#ֈ^}� �߷{��9�ht[>�w;�j��o�5zPP,���!����\���G���y���N��O�O���wg�v����g͓��������I��ݧ�u�u�K�YG�9b��n�=|m�O���4�Q���u�����~�yq����y��*���P��;bvj8�m]z�b^���ṛ̲�=Lp���!��W^�rO[������	��T�'�o�@�'s������D/uX����Y���>�_�˓��/�\._��.|�O:��IIߡc.�t܀��1e���P�Q�Q�"�B݈���1$�O`�"����(��Zg&�\��,�-��׃��qL�#e���s�����r�7�(G��0�ԥCd������SR��AW�"{��-P;�O	��������j0�\���W<�$��q!�)��s!����!��`�5�F��c���E�6�(j���[�0�RE¡I����p`��u?x��J]�3�>-�qT�	�؈%��CI�ˊr؁�1WT��	!����.1��uͭ)��Hp(���s�Y���j�h�����F��_�袙��(tz��y�s?�}]��#����L�ڑ��l�r�ҧ W+aa%�=�@�j����O����_r��İ(e���	hX���1!�0��*������q�A����|��ɬc�/2M��ϧSJ#J�'�4v��)kԯ�t ��Q�7q\�-���v��Jʛڑk�S �����p�*��s)��*X����Q�3oJ�����#�w����Xv��epc2�rT���F���wX�O� �7'���q�^>�7H�>40O�6��$��z�N�"CĎb�#�L��I&��{ B�����wG=�J�u�p��s���F���o���Z*o�+ߔ* �#�:z�H?�a[���)/I���C"[(�1o�����ȿ�)�W�ZL�Cͳ�����j|���'��~">u��8�Z��YRN�Vh��9hl��4���vd�(h��tDS<��Y��KU�F�p��L&�C{�&^A�'7�Hˋc��"e�)��������;Z��|E�$��lߝDkt*��hqa������̮ hg���B�j�N[���^%�B�{���|�͑K�5��&|O���*k ��	gF��1�Eyp���Ȣ}%��("�'����A�6��$�PDC��a��#b���E"���ZQNC��c1 ���FܨeM�A:�>�����\	��������t�������6j[���W������E��%�)?g���b��~2%�Ad�Ad�Ad�Ad�Ad�Ad�Ad�Ad�Ad�A�/�#M x  