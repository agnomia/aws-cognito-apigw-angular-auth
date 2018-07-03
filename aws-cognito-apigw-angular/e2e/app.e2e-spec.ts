import { AwsCognitoApigwAngularPage } from './app.po';

describe('aws-cognito-apigw-angular App', () => {
  let page: AwsCognitoApigwAngularPage;

  beforeEach(() => {
    page = new AwsCognitoApigwAngularPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
