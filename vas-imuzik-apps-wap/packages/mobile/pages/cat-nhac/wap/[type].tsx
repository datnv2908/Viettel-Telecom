import { NextPageContext } from 'next';
import React from 'react';

import { withApollo } from '../../../src/helpers/apollo';
import { TrimmerBaseForWap } from '../../../src/screens/ProfileStack/TrimmerScreenForWap';

function TrimmerPage({ data }: { data: any }) {
    return (
        <>
            <TrimmerBaseForWap
                url={data.url}
                name={data.name}
                type={data.type}
                id={data.id}
                songName={data.songName}
                singerName={data.singerName}
                composer={data.composer} />
        </>
    );
}
TrimmerPage.getInitialProps = ({ req, query, pathname }: NextPageContext) => {
    const data = { url: req?.url, pathname, ...query };
    return { data }
};
export default withApollo({ ssr: false })(TrimmerPage);
